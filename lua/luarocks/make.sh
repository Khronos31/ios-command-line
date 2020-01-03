#!/bin/bash

export CC=clang
export CXX=clang++
export AR=llvm-ar

export URL="https://luarocks.org/releases/luarocks-3.2.1.tar.gz"


case "$1" in
	download)
		curl -Lo luarocks.tar.gz "$URL"
		tar xvf luarocks.tar.gz
		rm luarocks.tar.gz
		exit 0
	;;
	make)
		echo "Making..."
		cd luarocks-3.2.1
		./configure --prefix=/usr/local
		make
		exit 0
	;;
	clean)
		echo "Cleaning..."
		cd luarocks-3.2.1
		make clean
		exit 0
	;;
	purge)
		echo "Purging..."
		rm -rf luarocks-3.2.1
		exit 0
	;;
	package)
		echo "Packing"
		prefix=/usr/local
		destdir=$(pwd)/deb/${prefix}
		mkdir -p ${destdir}
		cd luarocks-3.2.1
		make install prefix=${destdir} sysconfdir='$(prefix)/etc' rocks_tree='$(prefix)'
		dpkg-deb --build -Zxz deb package.deb
		echo "TODO: auto clean up unneeded"
		exit 0
	;;
	patch)
		patchdir=patches
		for p in $(find $patchdir -name *.patch); do
			patch -u -p0 < "$p"
		done
	;;
	*)
		echo "Bad argument - \""$@"\"."
		exit 1
	;;
esac
