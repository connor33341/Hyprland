#!/bin/bash

# Exit on error
set -e

# Function to detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# Function to install dependencies on Arch Linux
install_arch() {
    echo "Detected Arch Linux. Installing dependencies using pacman and AUR..."

    # Update system and install base dependencies
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm base-devel git cmake ninja gcc pixman libdrm libinput wayland wayland-protocols libxkbcommon libdisplay-info tomlplusplus cpio

    # Install AUR helper (yay) if not present
    if ! command -v yay &> /dev/null; then
        echo "Installing yay AUR helper..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
    fi

    # Install Hyprland dependencies from AUR
    yay -S --noconfirm hyprwayland-scanner-git hyprutils-git hyprlang-git hyprcursor-git hyprgraphics-git aquamarine-git
}

# Function to install dependencies on Ubuntu/Debian
install_ubuntu_debian() {
    echo "Detected Ubuntu/Debian. Installing dependencies and building from source..."

    # Update system and install base dependencies
    sudo apt update
    sudo apt install -y build-essential git cmake ninja-build g++ libpixman-1-dev libdrm-dev libinput-dev libwayland-dev wayland-protocols libxkbcommon-dev libdisplay-info-dev libtomlplusplus-dev cpio

    # Function to build and install a package from source
    build_and_install() {
        local repo_url="$1"
        local pkg_name="$2"
        local build_type="${3:-cmake}" # Default to cmake, can be meson
        echo "Building and installing $pkg_name..."

        # Clone the repository
        git clone "$repo_url" "/tmp/$pkg_name"
        cd "/tmp/$pkg_name"

        # Build and install
        if [ "$build_type" = "meson" ]; then
            mkdir build && cd build
            meson setup --prefix=/usr ..
            ninja
            sudo ninja install
        else
            mkdir build && cd build
            cmake -D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release -D CMAKE_SKIP_INSTALL_RPATH=ON -G Ninja ..
            ninja
            sudo ninja install
        fi

        # Clean up
        cd /tmp
        rm -rf "/tmp/$pkg_name"
    }

    # Install dependencies in order (resolving inter-dependencies)
    build_and_install "https://github.com/hyprwm/hyprwayland-scanner" "hyprwayland-scanner" "meson"
    build_and_install "https://github.com/hyprwm/hyprutils" "hyprutils"
    build_and_install "https://github.com/hyprwm/hyprlang" "hyprlang"
    build_and_install "https://github.com/hyprwm/hyprcursor" "hyprcursor"
    build_and_install "https://github.com/hyprwm/hyprgraphics" "hyprgraphics"
    build_and_install "https://github.com/hyprwm/aquamarine" "aquamarine"
}

# Main script
DISTRO=$(detect_distro)
echo "Distribution: $DISTRO"

case "$DISTRO" in
    arch)
        install_arch
        ;;
    ubuntu|debian|linuxmint)
        install_ubuntu_debian
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        echo "Please install the following manually: aquamarine, hyprlang, hyprcursor, hyprutils, hyprgraphics, hyprwayland-scanner"
        exit 1
        ;;
esac

# Verify installations
echo "Verifying installations..."
for pkg in hyprwayland-scanner hyprutils hyprlang hyprcursor hyprgraphics aquamarine; do
    if [ -d "/usr/lib/$pkg" ] || [ -f "/usr/bin/$pkg" ] || [ -f "/usr/lib/lib$pkg.so" ]; then
        echo "$pkg: Installed"
    else
        echo "$pkg: Not found, installation may have failed"
    fi
done

echo "Dependency installation complete. You can now build Hyprland."