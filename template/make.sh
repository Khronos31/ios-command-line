#!/bin/bash

export CC=clang
export CXX=clang++
export AR=llvm-ar

export URL=""


case "$1" in
	download)
		curl -o source.tar.gz "$URL"
		tar xvf source.tar.gz
		rm source.tar.gz
		exit 0
	;;
	make)
		echo "Making..."
		exit 0
	;;
	clean)
		echo "Cleaning..."
		exit 0
	;;
	purge)
		echo "Purging..."
		exit 0
	;;
	package)
		echo "Packing"
		prefix=/usr/local
		mkdir -p $(pwd)/deb/${prefix}
		dpkg-deb --build --root-owner-group -Zxz deb package.deb
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
