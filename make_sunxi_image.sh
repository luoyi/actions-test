#!/bin/bash

UBOOT_FILE="u-boot-2021.10.tar.bz2"
UBOOT_URL="https://ftp.denx.de/pub/u-boot/${UBOOT_FILE}"
UBOOT_DIR="u-boot-2021.10"
WORK_DIR="$HOME/sunxi_image"

function prepare_env {
        sudo -E apt-get -qq update
        sudo -E apt-get -qq install swig python-dev gcc-arm-linux-gnueabihf device-tree-compiler
        sudo -E apt-get -qq autoremove --purge
        sudo -E apt-get -qq clean	
}

function compile_uboot {
	THE_DIR=$(pwd)
	mkdir -p "$WORK_DIR"
	cd "$WORK_DIR"
	wget -q "$UBOOT_URL"
	tar xf "$UBOOT_FILE"
	cd "$UBOOT_DIR"
	cp ${THE_DIR}/boot.cmd ./
	ls -alh
	make CROSS_COMPILE=arm-linux-gnueabihf- nanopi_m1_plus_defconfig
  make CROSS_COMPILE=arm-linux-gnueabihf-
  ./tools/mkimage -C none -A arm -T script -d boot.cmd boot.scr
  ls -alh u-boot-sunxi-with-spl.bin  boot.scr
	mkdir -p "$WORK_DIR/output"
	cp u-boot-sunxi-with-spl.bin  boot.scr $WORK_DIR/output/
  ls -alh $WORK_DIR/output/
}


prepare_env
compile_uboot
