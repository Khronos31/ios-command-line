#!/bin/bash

set -e
set -u

CURRENTDIR="${CURRENTDIR:-$(pwd)}"

cd Python-3.8.1


export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS7.1.sdk -miphoneos-version-min=7.0 -arch armv7 -I/usr/local/include -Wno-implicit-function-declaration'
export LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS7.1.sdk -miphoneos-version-min=7.0 -arch armv7 -L/usr/local/lib'

./configure --build=arm-apple-darwin --prefix=/usr/local --enable-shared --disable-static --enable-loadable-sqlite-extensions --with-signal-module --enable-big-digits --enable-ipv6 --enable-unicode --enable-unicode=ucs4 --with-system-expat --with-system-ffi --without-ensurepip --with-dbmloader=gdbm ac_cv_func_sendfile=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no&&
make -j3&&
make -j3 install DESTDIR=${CURRENTDIR}/build/armv7
