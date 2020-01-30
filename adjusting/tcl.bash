export CC=clang


grep -lr '\\\$rpath' .|xargs -n1 sed 's|\\\$rpath|@rpath|' -i


export CFLAGS='-isysroot /usr/SDK -arch arm64 -I/usr/local/include'
export LDFLAGS='-isysroot /usr/SDK -arch arm64 -L/usr/local/lib'

./configure --build=aarch64-apple-darwin --prefix=/usr/local --enable-shared&&
make&&
make install DESTDIR=$(pwd)/build/arm64

