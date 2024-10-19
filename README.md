# Docker OpenWrt Builder

Build [OpenWrt](https://openwrt.org/) images in a Docker container.

The docker image is based on Debian 10 (Buster).

Build tested:

- OpenWrt-19.07.4

## Quickstart

```sh
# build and start container
./setup.sh
```

## Build packages

```sh
cd build

. ../scripts/functions.sh

# choose 32bit or 64bit
# init armv7-3.2.config
# init aarch64-3.10.config

# setup entware
setup_entware_config
setup_entware_tools

# build packages
# ex: build_package screen

# build wpa-supplicant
build_package_custom_hostapd
```

In the container console, enter:

```sh
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make -j$(nproc) V=s
```

## Links

- [docker-openwrt-buildroot](https://github.com/noonien/docker-openwrt-buildroot)
- [openwrt-docker-toolchain](https://github.com/mchsk/openwrt-docker-toolchain)
- [Entware compile from source](https://github.com/Entware/Entware/wiki/Compile-packages-from-sources)
- [cross-compile-proxychains](https://www.snbforums.com/threads/solution-cross-compile-proxychains-ng-entware-package-via-debian-live-dvd.76960)
- [compile custom programs](https://github.com/RMerl/asuswrt-merlin.ng/wiki/Compile-custom-programs-from-source)
