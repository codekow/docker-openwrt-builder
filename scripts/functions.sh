#!/bin/bash

PATH_DIR=$( dirname "${BASH_SOURCE[0]}" )
ENTWARE_DIR=entware

init(){
  
  # 32bit
  # armv7-3.2.config

  # 64bit
  # aarch64-3.10.config
  
  CONFIG_FILE=${1:-aarch64-3.10.config}
  echo CONFIG_FILE=${CONFIG_FILE}
  echo PATH_DIR=${PATH_DIR}
  echo ENTWARE_DIR=${ENTWARE_DIR}

}
  
setup_entware_config(){
  # git clone
  git clone https://github.com/Entware/Entware.git ${ENTWARE_DIR}
  pushd ${ENTWARE_DIR}

  # Update OpenWRT Feeds
  ./scripts/feeds update -a
  make package/symlinks

  popd
}

setup_entware_tools(){
  pushd ${ENTWARE_DIR}
  cp configs/${CONFIG_FILE} .config

  make dirclean
  make -j$(nproc) tools/install
  make -j$(nproc) toolchain/install
  make -j$(nproc) target/compile
  popd
}

build_package(){
  pushd ${ENTWARE_DIR}
  make -j$(nproc) target/compile

  ./scripts/feeds install ${1}

  # debug
  # echo make -j1 V=sc package/${1}/download
  # echo make -j1 V=sc package/${1}/check
  find package/ -iname "*${1}*"

  make -j$(nproc) package/${1}/prepare
  make -j$(nproc) package/${1}/compile

  # debug
  # echo make -j1 V=sc package/${1}/prepare
  # echo make -j1 V=sc package/${1}/compile
  find bin/ -iname "*${1}*"
  popd
}

build_package_custom_hostapd(){
  pushd ${ENTWARE_DIR}
  cp configs/${CONFIG_FILE} .config
  patch -s -p 0 < wpa_supplicant/patch.hostapd
  patch -s -p 0 < wpa_supplicant/patch.libubus

  build_package hostapd
  find bin/ -name "[wpa|hostapd]*.ipk"
  popd
}

echo 32bit
echo init armv7-3.2.config

echo 64bit
echo init aarch64-3.10.config
echo

init
#setup_entware_config
#setup_entware_tools

#build_package screen
#build_package_custom_hostapd