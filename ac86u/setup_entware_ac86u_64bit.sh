#!/bin/bash


setup_entware_config(){

# git clone
git clone https://github.com/Entware/Entware.git entware
cd entware

# Update OpenWRT Feeds
./scripts/feeds update -a
make package/symlinks

}

setup_entware_tools(){	

# Copy the config specific to your Architecture and Kernel versions
#cp configs/armv7-3.2.config .config
cp configs/aarch64-3.10.config .config

make dirclean
make -j$(nproc) tools/install
make -j$(nproc) toolchain/install
make -j$(nproc) target/compile
}

setup_entware_config
setup_entware_tools
