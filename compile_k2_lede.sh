#!/bin/bash


function prepare_env {
        sudo -E apt-get -qq update
		sudo -E apt-get -qq -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync
        sudo -E apt-get -qq autoremove --purge
        sudo -E apt-get -qq clean	
}

function k2_lede {
	THE_DIR=$(pwd)
	WORK_DIR="$HOME/k2_lede"
	mkdir -p "$WORK_DIR"
	cd "$WORK_DIR"
	wget 'https://github.com/coolsnowwolf/lede/archive/refs/tags/20211107.tar.gz'
	tar xf 20211107.tar.gz
	cd lede-20211107/
	./scripts/feeds update -a
	./scripts/feeds install -a
	make -j8 download V=s
	cp ${THE_DIR}/k2_lede_config ./.config
	make -j2 V=s
}

prepare_env
k2_lede
