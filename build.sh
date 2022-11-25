#!/bin/bash
set -xe
if [[ $1 = "docker" ]]; then
	docker build -t fold .
	docker run --privileged --rm -it -v "$PWD":/build fold
	exit
fi

[ -d build ] || git clone https://gitlab.com/ubports/community-ports/halium-generic-adaptation-build-tools -b halium-11 build
./build/build.sh "$@"
