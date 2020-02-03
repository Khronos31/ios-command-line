export CC=clang


grep -lr -- '-install_name'|grep configure|xargs -n1 sed 's|\\\$rpath|@rpath|' -i


export CFLAGS='-isysroot /usr/SDK -arch arm64'
export LDFLAGS='-isysroot /usr/SDK -arch arm64'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared --enable-static=no&&
make&&
make install DESTDIR=$(pwd)/build/arm64


make clean


export CFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'
export LDFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'

./configure --build=arm-apple-darwin --prefix=/usr/local --enable-shared --enable-static=no&&
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

