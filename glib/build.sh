#!/bin/bash

unset PYTHON
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export CXXFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export LIBFFI_CFLAGS=" "
export LIBFFI_LIBS="-lffi"

./configure --prefix=$PREFIX
make -j4
make install
