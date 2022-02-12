#!/bin/bash

build_package(){

make -j$(nproc) target/compile

./scripts/feeds install ${1}

#echo make -j1 V=sc package/${1}/download
#echo make -j1 V=sc package/${1}/check
find package/ -iname "*${1}*"

make -j$(nproc) package/${1}/prepare
make -j$(nproc) package/${1}/compile

#echo make -j1 V=sc package/${1}/prepare
#echo make -j1 V=sc package/${1}/compile
find bin/ -iname "*${1}*"
}

build_package_custom_hostapd(){

cp configs/armv7-3.2.config .config
#cp configs/aarch64-3.10.config .config
patch -s -p 0 < ../patch.hostapd
patch -s -p 0 < ../patch.libubus
# diff -u configs/aarch64-3.10.config .config > ../patch.hostapd

build_package hostapd

find bin/ -name "*.ipk"
}

#build_package screen
build_package_custom_hostapd
