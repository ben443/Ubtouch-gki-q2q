FROM ubuntu:20.04

RUN apt update && \
	apt install -y --no-install-recommends \
		android-tools-mkbootimg \
		bc \
		bison \
		build-essential \
		ca-certificates \
		cpio \
		curl \
		flex \
		git \
		kmod \
		libssl-dev \
		libtinfo5 \
		python2 \
		sudo \
		unzip \
		wget \
		xz-utils \
		git \
		img2simg \
		jq \
		p7zip-full \
		gzip

RUN ln -sf python2.7 /usr/bin/python
RUN wget https://raw.githubusercontent.com/LineageOS/android_system_tools_mkbootimg/lineage-19.1/mkbootimg.py -O /usr/bin/mkbootimg

SHELL ["/bin/bash", "-c"]

CMD cd /build && \
	./build/build.sh && \
	DEVICE="$(source deviceinfo && echo $deviceinfo_codename)" ./build/prepare-fake-ota.sh out/device_$DEVICE.tar.xz ota && \
	./build/system-image-from-ota.sh ota/ubuntu_command out && \
	mv out/rootfs.img out/ubuntu.img
