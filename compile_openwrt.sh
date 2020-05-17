#!/bin/bash

#1  download the openwrt sdk from http://downloads.openwrt.org 
#2  fetch some required packages
#3  compile the whole world


THE_SDK_DIR="openwrt-sdk-19.07.2-ipq40xx-generic_gcc-7.5.0_musl_eabi.Linux-x86_64"
THE_SDK_FILE="${THE_SDK_DIR}.tar.xz"
THE_SDK="https://downloads.openwrt.org/releases/19.07.2/targets/ipq40xx/generic/$THE_SDK_FILE"
WORK_DIR="$HOME/openwrt_work"

function prepare_env {
        sudo -E apt-get -qq update
        sudo -E apt-get -qq install build-essential asciidoc binutils bzip2 gawk \
				gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev \
				lib32gcc1 libc6-dev-i386 subversion flex uglifyjs gcc-multilib \
				g++-multilib p7zip p7zip-full msmtp libssl-dev texinfo \
				libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake \
				libtool autopoint device-tree-compiler antlr3 gperf tree
        sudo -E apt-get -qq autoremove --purge
        sudo -E apt-get -qq clean	
}

function download_sdk {
	THE_DIR=$(pwd)
	mkdir -p "$WORK_DIR"
	cd "$WORK_DIR"
	wget -q "$THE_SDK"
	tar xf "$THE_SDK_FILE"
	cd "$THE_SDK_DIR"
	cp ${THE_DIR}/ipq40xx.config ./.config
	ls -alh
	./scripts/feeds update -a
	./scripts/feeds install -a
	git clone https://github.com/shadowsocks/openwrt-feeds.git package/feeds
	git clone https://github.com/aa65535/openwrt-simple-obfs.git package/simple-obfs
	make package/simple-obfs/compile V=99
	tree bin
}

prepare_env
download_sdk

