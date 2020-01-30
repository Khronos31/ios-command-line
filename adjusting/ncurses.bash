export CC=clang
export CXX=clang++
export AR=llvm-ar
export RANLIB=llvm-ranlib


grep -lr -- '-install_name' .|xargs -n1 sed -i -e 's|-install_name [^/]*|-install_name @rpath|'


export CFLAGS='-isysroot /usr/SDK -arch arm64'
export CXXFLAGS='-isysroot /usr/SDK -arch arm64'
export LDFLAGS='-isysroot /usr/SDK -arch arm64'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --with-shared --without-debug --without-normal --enable-pc-files&&
make&&
make install DESTDIR=$(pwd)/build/arm64

make clean&&
./configure --build=aarch64-apple-darwin --prefix=/usr/local --with-shared --without-debug --without-normal --enable-pc-files --enable-widec&&
make&&
make install DESTDIR=$(pwd)/build/arm64


make clean


export CFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'
export CXXFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'
export LDFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --with-shared --without-debug --without-normal --enable-pc-files&&
make&&
make install DESTDIR=$(pwd)/build/armv7

make clean&&
./configure --build=aarch64-apple-darwin --prefix=/usr/local --with-shared --without-debug --without-normal --enable-pc-files --enable-widec&&
make&&
make install DESTDIR=$(pwd)/build/armv7


mkdir -p build/linked
cp -r build/arm64/* build/linked/

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

