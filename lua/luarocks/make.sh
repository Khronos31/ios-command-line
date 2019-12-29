./configure --prefix=/usr/local
make
make install prefix=$(pwd)/build/usr/local sysconfdir='$(prefix)/etc' rocks_tree='$(prefix)'

