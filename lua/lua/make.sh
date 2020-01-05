currentdir=$(pwd)


cd src
make o a dylib SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib"
make luac SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib"
make lua SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch arm64 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch arm64 -L/usr/local/lib" SYSLIBS="-lreadline"
cd $currentdir
make install INSTALL_TOP="$(pwd)/build/arm64/usr/local"


make clean


cd src
make o a dylib SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib"
make luac SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib"
make lua SYSCFLAGS="-DLUA_USE_MACOSX -isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -I/usr/local/include" SYSLDFLAGS="-isysroot /usr/SDK -arch armv7 -miphoneos-version-min=7.0 -L/usr/local/lib" SYSLIBS="-lreadline"
cd $currentdir
make install INSTALL_TOP="$(pwd)/build/armv7/usr/local"


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
