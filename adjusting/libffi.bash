export CC=clang


sed 's|\\\$rpath|@rpath|' -i configure


export CFLAGS='-isysroot /usr/SDK -arch arm64 -I/usr/local/include'
export LDFLAGS='-isysroot /usr/SDK -arch arm64 -L/usr/local/lib'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-static=no&&
make&&
make install DESTDIR=$(pwd)/build/arm64


make clean


export CFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include'
export LDFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib'

./configure --build=arm-apple-darwin --prefix=/usr/local --enable-static=no&&
make&&
make install DESTDIR=$(pwd)/build/armv7


mkdir -p build/linked
cp -r build/arm64/* build/linked/

find build/ -type f -name '*.dylib'|
xargs chmod +x
find build/linked -type f|
while read x;do
  if lipo -info $x >/dev/null 2>&1;then
    rm $x
    lipo -create ${x/linked/armv7} ${x/linked/arm64} -output $x
    if test -x $x;then
      ldid -S/usr/share/SDKs/x.ent ${x/arm64/linked}
    fi
  fi
done

