#!/bin/bash

set -e
set -u

CURRENTDIR="$(pwd)"

wget https://nim-lang.org/download/nim-1.0.4.tar.xz


tar xvf nim-1.0.4.tar.xz

for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done

cd nim-1.0.4

destdir="${CURRENTDIR}/build/arm64"
mkdir bin
cp $(which nim) bin/nim
./bin/nim compile --os:macosx --cpu:arm64 koch
./koch boot --os:macosx --cpu:arm64 -d:release
./bin/nim compile --os:macosx --cpu:arm64 -d:release koch
./koch tools --os:macosx --cpu:arm64 -d:release
./install.sh "${destdir}"
cp bin/* "${destdir}/nim/bin/"
cp copying.txt "${destdir}/nim/"
cd "${CURRENTDIR}"
rm -r nim-1.0.4


tar xvf nim-1.0.4.tar.xz

for p in $(find patches -name *.patch); do
  patch -u -p0 < "$p"
done

cd nim-1.0.4

destdir="${CURRENTDIR}/build/armv7"
mkdir bin
cp $(which nim) bin/nim
./bin/nim compile --os:macosx --cpu:arm koch
./koch boot --os:macosx --cpu:arm -d:release
./bin/nim compile --os:macosx --cpu:arm -d:release koch
./koch tools --os:macosx --cpu:arm -d:release
./install.sh "${destdir}"
cp bin/* "${destdir}/nim/bin/"
cd "${CURRENTDIR}"
rm -r nim-1.0.4


mkdir -p build/linked
cp -r build/arm64/* build/linked/

find build/linked -type f|
while read x;do
  if lipo -info $x >/dev/null 2>&1; then
    rm $x
    lipo -create ${x/linked/armv7} ${x/linked/arm64} -output $x
    if test -x $x; then
      ldid -S/usr/share/SDKs/x.ent $x
    fi
  fi
done

cp -r build/linked/* deb/usr/local/libexec/

mkdir -p deb/usr/local/bin
ls deb/usr/local/libexec/nim/bin|
while read l;do
  ln -s "../libexec/nim/bin/$l" "deb/usr/local/bin/$l"
done
