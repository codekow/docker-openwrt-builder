# Docker OpenWrt Builder

Build [OpenWrt](https://openwrt.org/) images in a Docker container. 

The docker image is based on Debian 10 (Buster).

Build tested:

- OpenWrt-19.07.4

A smaller container based on Alpine Linux is available as `Dockerfile.alpine`

## Prerequisites

* Docker / Podman installed
* build Docker image:

```
docker build -t openwrt_builder .
docker build -t openwrt_builder_debian -f Dockerfile.debian .
```

## Usage GNU/Linux

Create a build folder and link it into a new docker container:
```
mkdir ~/build
docker run --name openwrt_builder \
  -v $(pwd)/build:/home/builder \
  -it openwrt_builder /bin/bash
```

In the container console, enter:
```
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make -j$(nproc) V=s
```

## Links
* [docker-openwrt-buildroot](https://github.com/noonien/docker-openwrt-buildroot)
* [openwrt-docker-toolchain](https://github.com/mchsk/openwrt-docker-toolchain)
* [Entware compile from source](https://github.com/Entware/Entware/wiki/Compile-packages-from-sources)
* [cross-compile-proxychains](https://www.snbforums.com/threads/solution-cross-compile-proxychains-ng-entware-package-via-debian-live-dvd.76960)
* [compile custom programs](https://github.com/RMerl/asuswrt-merlin.ng/wiki/Compile-custom-programs-from-source)
