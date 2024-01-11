#!/bin/bash
set -xe
if [[ $1 = "docker" ]]; then
	docker build -t fold .
	docker run --privileged --rm -it -v "$PWD":/build fold
	exit
fi

[ -d build ] || git clone https://github.com/ben443/halium-generic-adaptation-build-tools -b halium-12 build
./build/build.sh "$@"
./build/prepare-fake-ota.sh ./out/device_r8q_usrmerge.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
mv out/rootfs.img out/ubuntu.img
