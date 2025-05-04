sudo do-release-upgrade
sudo add-apt-repository ppa:oibaf/graphics-drivers
# TO REVERT, RUN:
# sudo apt install ppa-purge
# sudo ppa-purge ppa:oibaf/graphics-drivers

sudo apt update
sudo apt install libwayland-dev wayland-protocols