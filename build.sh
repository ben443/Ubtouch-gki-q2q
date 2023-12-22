#!/bin/bash
set -xe
if [[ $1 = "docker" ]]; then
	docker build -t fold .
	docker run --privileged --rm -it -v "$PWD":/build fold
	exit
fi

[ -d build ] || git clone https://gitlab.com/ubports/porting/community-ports/halium-generic-adaptation-build-tools -b halium-12 build
./build/build.sh -b . "$@"
./build/prepare-fake-ota.sh ./out/device_q2q_usrmerge.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
mv out/rootfs.img out/ubuntu.img
