#!/bin/bash

set -e
set -u

CURRENTDIR="$(pwd)"

wget https://www.lua.org/ftp/lua-5.3.5.tar.gz
tar xvf lua-5.3.5.tar.gz
rm lua-5.3.5.tar.gz

for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done

cd lua-5.3.5

cd src
make o a dylib SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib"
make luac SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib"
make lua SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib" SYSLIBS="-lreadline"
cd ..
make install INSTALL_TOP="$CURRENTDIR/build/arm64/usr/local"


make clean


cd src
make o a dylib SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib"
make luac SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib"
make lua SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib" SYSLIBS="-lreadline"
cd ..
make install INSTALL_TOP="${CURRENTDIR}/build/armv7/usr/local"

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