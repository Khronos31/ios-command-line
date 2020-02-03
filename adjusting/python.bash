export CC=clang
export CXX=clang++
export AR=llvm-ar
export RANLIB=llvm-ranlib


# sed 's|-install_name,[^/]*/lib/|-install_name,@rpath/|' -i Makefile.pre.in


# export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -I/usr/include -I/usr/local/include -Wno-implicit-function-declaration'
# export CXXFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -I/usr/include -I/usr/local/include -Wno-implicit-function-declaration'
# export LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/lib -L/usr/local/lib'
export CFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -I/usr/local/include -Wno-implicit-function-declaration'
# export CPPFLAGS='-I/usr/local/include/ncursesw'
unset CXXFLAGS
unset LDFLAGS


./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared --disable-static --enable-loadable-sqlite-extensions --with-signal-module --enable-big-digits --enable-ipv6 --enable-unicode --enable-unicode=ucs4 --with-system-expat --with-system-ffi --without-ensurepip --with-dbmloader=gdbm ac_cv_func_sendfile=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no&&
make -j3 LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/local/lib'&&
make -j3 install DESTDIR=$(pwd)/../installed LDFLAGS='-isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -L/usr/lib -L/usr/local/lib'

: <<'EOF'
make clean


export CFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'
export CXXFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'
export LDFLAGS='-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared&& # --with-system-expat --system-ffi --without-ensurepip&&
make&&
make install DESTDIR=$(pwd)/../build/armv7


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

EOF