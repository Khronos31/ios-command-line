#!/bin/bash

set -e
set -u

CURRENTDIR="${CURRENTDIR:-$(pwd)}"

cd Python-3.8.1


export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -I/usr/local/include -Wno-implicit-function-declaration'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared --disable-static --enable-loadable-sqlite-extensions --with-signal-module --enable-big-digits --enable-ipv6 --enable-unicode --enable-unicode=ucs4 --with-system-expat --with-system-ffi --without-ensurepip --with-dbmloader=gdbm ac_cv_func_sendfile=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no&&
make -j3 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/local/lib'&&
make -j3 install DESTDIR=${CURRENTDIR}/build/arm64 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/lib -L/usr/local/lib'
