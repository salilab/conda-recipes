#!/bin/sh

./configure --prefix=$PREFIX --enable-shared --disable-fortran

make
make install

# vim:set ts=8 sw=4 sts=4 tw=78 et:
