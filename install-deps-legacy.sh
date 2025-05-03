mkdir ~/hyprland-deps && cd ~/hyprland-deps
git clone https://github.com/hyprwm/aquamarine.git
git clone https://github.com/hyprwm/hyprlang.git
git clone https://github.com/hyprwm/hyprcursor.git
git clone https://github.com/hyprwm/hyprutils.git
git clone https://github.com/hyprwm/hyprgraphics.git

#sudo add-apt-repository ppa:ubuntu-toolchain-r/test
#sudo apt update
#sudo apt install -y g++-14

cd ~/hyprland-deps/hyprutils
mkdir build && cd build
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S .. -B .
cmake --build . --config Release --target all -j$(nproc)
sudo cmake --install .

cd ~/hyprland-deps/hyprlang
mkdir build && cd build
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S .. -B .
cmake --build . --config Release --target all -j$(nproc)
sudo cmake --install .

cd ~/hyprland-deps/hyprcursor
mkdir build && cd build
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S .. -B .
cmake --build . --config Release --target all -j$(nproc)
sudo cmake --install .

cd ~/hyprland-deps/hyprgraphics
mkdir build && cd build
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S .. -B .
cmake --build . --config Release --target all -j$(nproc)
sudo cmake --install .

cd ~/hyprland-deps/aquamarine
mkdir build && cd build
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S .. -B .
cmake --build . --config Release --target all -j$(nproc)
sudo cmake --install .