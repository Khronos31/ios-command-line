#!/bin/bash

set -e
set -u

./luarocks.sh download
./luarocks.sh patch
./luarocks.sh make
./luarocks.sh package
