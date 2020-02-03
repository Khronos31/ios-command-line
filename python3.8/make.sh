#!/bin/bash

set -e
set -u

CURRENTDIR="$(pwd)"

export CC=clang
export CXX=clang++
export AR=llvm-ar
export RANLIB=llvm-ranlib
unset CXXFLAGS
unset LDFLAGS

wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz
tar xvf Python-3.8.1.tar.xz
rm Python-3.8.1.tar.xz

for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done

cd Python-3.8.1


export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -I/usr/local/include -Wno-implicit-function-declaration'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared --disable-static --enable-loadable-sqlite-extensions --with-signal-module --enable-big-digits --enable-ipv6 --enable-unicode --enable-unicode=ucs4 --with-system-expat --with-system-ffi --without-ensurepip --with-dbmloader=gdbm ac_cv_func_sendfile=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no&&
make -j3 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/local/lib'&&
make -j3 install DESTDIR=${CURRENTDIR}/build/arm64 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/lib -L/usr/local/lib'


cd ${CURRENTDIR}
rm -r Python-3.8.1
tar xvf Python-3.8.1.tar.xz
cd Python-3.8.1


export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7 -I/usr/local/include -Wno-implicit-function-declaration'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared --disable-static --enable-loadable-sqlite-extensions --with-signal-module --enable-big-digits --enable-ipv6 --enable-unicode --enable-unicode=ucs4 --with-system-expat --with-system-ffi --without-ensurepip --with-dbmloader=gdbm ac_cv_func_sendfile=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no&&
make -j3 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7 -L/usr/local/lib'&&
make -j3 install DESTDIR=${CURRENTDIR}/build/armv7 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7 -L/usr/lib -L/usr/local/lib'


cd ${CURRENTDIR}

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