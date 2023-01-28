#!/bin/bash
set -xe
if [[ $1 = "docker" ]]; then
	docker build -t fold .
	docker run --privileged --rm -it -v "$PWD":/build fold
	exit
fi

[ -d build ] || git clone https://gitlab.com/Azkali/halium-generic-adaptation-build-tools -b halium-11-focal build
./build/build.sh "$@"
./build/prepare-fake-ota.sh ./out/device_q2q_usrmerge.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
mv out/rootfs.img out/ubuntu.img

mount out/ubuntu.img

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
DEBIAN_FRONTEND=noninteractive \
LANG=C RUNLEVEL=1 \
chroot /mnt /bin/bash <<EOF
echo phablet:phablet | chpasswd
EOF

umount out/ubuntu.img
