#!/bin/bash

init(){
  
  # 32bit
  # armv7-3.2.config

  # 64bit
  # aarch64-3.10.config
  
  CONFIG_FILE=${1:-aarch64-3.10.config}
  echo CONFIG_FILE=${CONFIG_FILE}

  PATH_DIR=$( dirname "${BASH_SOURCE[0]}")
  echo PATH_DIR=${PATH_DIR}

}
  
setup_entware_config(){
  # git clone
  git clone https://github.com/Entware/Entware.git entware
  cd entware

  # Update OpenWRT Feeds
  ./scripts/feeds update -a
  make package/symlinks
}

setup_entware_tools(){

  cp configs/${CONFIG_FILE} .config

  make dirclean
  make -j$(nproc) tools/install
  make -j$(nproc) toolchain/install
  make -j$(nproc) target/compile
}

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
  cp configs/${CONFIG_FILE} .config
  patch -s -p 0 < ${PATH_DIR}/patch.hostapd
  patch -s -p 0 < ${PATH_DIR}/patch.libubus

  build_package hostapd

  find bin/ -name "[wpa|hostapd]*.ipk"
}

# 32bit
# init armv7-3.2.config

# 64bit
init aarch64-3.10.config

#setup_entware_config
#setup_entware_tools

#build_package screen
#build_package_custom_hostapd