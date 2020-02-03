#!/bin/bash

set -e
set -u

export CURRENTDIR="$(pwd)"

export CC=clang
export CXX=clang++
export AR=llvm-ar
export RANLIB=llvm-ranlib
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz


tar xvf Python-3.8.1.tar.xz
for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done
./arm64.sh


rm -r Python-3.8.1


tar xvf Python-3.8.1.tar.xz
for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done
./armv7.sh


mkdir -p build/linked
cp -r build/arm64/* build/linked/

find build/linked -type f|
while read x;do
  if lipo -info $x >/dev/null 2>&1;then
    rm $x
    lipo -create ${x/linked/armv7} ${x/linked/arm64} -output $x
    if test -x $x;then
      ldid -S/usr/share/SDKs/x.ent $x
    fi
  fi
done

cp -r build/linked/* deb/
