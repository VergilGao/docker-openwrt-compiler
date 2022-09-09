#!/bin/bash

set -eu

config_file=/config/build.config

if [ ! -d /src/openwrt/.git ]; then
    rm -rf /src/openwrt && git clone $REPO_URL -b $REPO_BRANCH /src/openwrt && cd /src/openwrt
else
    cd /src/openwrt && git reset --hard && git clean -f && git pull
fi

rm -rf ./bin/targets
[ -e /config/feeds.conf ] && cp -f /config/feeds.conf feeds.conf.default
[ -e /opt/part1.sh ] && /opt/part1.sh
./scripts/feeds update -a
./scripts/feeds install -a
[ -e /config/files ] && cp -f /config/files files
[ -e /opt/part2.sh ] && /opt/part2.sh

if [ ! -e $config_file ]; then
    echo "no build.config exits, we will make a new build.config for you."
    [ -e /config/seed.config ] && cp -f /config/seed.config .config
    make menuconfig
    rm -f .config.old
    make defconfig
    ./scripts/diffconfig.sh > $config_file
else
    cp -f $config_file .config
    make defconfig
fi

make download -j$(nproc)
if [ -e /config/nproc ] && [ -n "$(cat /config/nproc | sed -n "/^[0-9]\+$/p")" ]; then
    make V=s -j$(cat /config/nproc)
else
    make V=s -j1
fi

cd /src/openwrt/bin/targets/*/*
firmware_path="/build/firmware-$DEVICE_NAME-$(date +%Y%m%d%H%M)"
mkdir -p "$firmware_path" && mv ./* "$firmware_path"
