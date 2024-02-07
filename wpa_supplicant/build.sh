#!/bin/bash

# https://github.com/entware/entware/wiki/Compile-packages-from-sources
# https://openwrt.org/docs/guide-developer/toolchain/single.package

GIT_ENTWARE=https://github.com/Entware/Entware.git
GIT_OPENWRT=https://git.openwrt.org/openwrt/openwrt.git
WRT_VERSION=23.05.2
CFG_BPI_R3=https://downloads.openwrt.org/releases/23.05.2/targets/mediatek/filogic/config.buildinfo


SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
ENTWARE_DIR=entware

info(){
  echo USAGE:
  echo
  echo 32bit
  echo build_package_custom_hostapd_32bit

  echo 64bit
  echo build_package_custom_hostapd_64bit
  echo
}

clone_entware(){
  git clone ${GIT_ENTWARE} ${ENTWARE_DIR}
  pushd ${ENTWARE_DIR}
  git checkout .
  git pull
  popd
}
  
setup_entware_config(){
  CONFIG_FILE=${1:-aarch64-3.10}

  echo CONFIG_FILE=${CONFIG_FILE}
  echo

  clone_entware
  pushd ${ENTWARE_DIR}

  # Update the feeds
  ./scripts/feeds update -a
  make package/symlinks

  [ -e .config ] || cp configs/${CONFIG_FILE}.config .config
  grep -q "${CONFIG_FILE}" .config || make dirclean
  cp configs/${CONFIG_FILE}.config .config
  # make oldconfig

  popd
}

setup_entware_tools(){
  pushd ${ENTWARE_DIR}

  make -j$(nproc) tools/install
  make -j$(nproc) toolchain/install
  # make -j$(nproc) target/compile
  popd
}

setup_openwrt_config(){
  git clone ${GIT_OPENWRT} openwrt
  pushd openwrt
  git pull
 
  git branch -a
  git tag
  git checkout v${WRT_VERSION}
 
  # Update the feeds
  ./scripts/feeds update -a
  ./scripts/feeds install -a

  # cp configs/${CONFIG_FILE} .config
  wget ${CFG_BPI_R3} -O .config
  make oldconfig

  popd 
}

build_package(){
  pushd ${ENTWARE_DIR}
  # make -j$(nproc) target/compile

  ./scripts/feeds install ${1}

  # debug
  # echo make -j1 V=sc package/${1}/download
  # echo make -j1 V=sc package/${1}/check
  find package/ -iname "*${1}*"

  make -j$(nproc) package/${1}/prepare || \
    make -j1 V=sc package/${1}/prepare
  make -j$(nproc) package/${1}/compile || \
    make -j1 V=sc package/${1}/compile
  
  find bin/ -iname "*${1}*"
  popd
}

build_package_custom_hostapd(){
  pushd ${ENTWARE_DIR}

  patch --forward -l -s -p 0 < ../wpa_supplicant/patch.hostapd
  patch --forward -l -s -p 0 < ../wpa_supplicant/patch.libubus

  make -j$(nproc) target/compile
  popd
  
  build_package hostapd
  find bin/ -name "[wpa|hostapd]*.ipk"
}

build_package_custom_hostapd_32bit(){
  setup_entware_config armv7-3.2
  setup_entware_tools
  build_package_custom_hostapd
}

build_package_custom_hostapd_64bit(){
  setup_entware_config aarch64-3.10
  setup_entware_tools
  build_package_custom_hostapd
}

info
#setup_entware_config
#setup_entware_tools

#build_package screen
#build_package_custom_hostapd

