#!/bin/bash

export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export CXXFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

./configure --prefix=$PREFIX

make
# Don't run check for now; there is a bug in the poly test
# https://savannah.gnu.org/bugs/?40176
#make check
make install
