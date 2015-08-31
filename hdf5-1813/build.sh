#!/bin/bash

export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export CXXFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

# Put headers and libraries in a non-standard location so we don't clash
# with the regular HDF5 package. (In principle the libraries could go in the
# standard location, but the HDF5 folks don't always change the soversion with
# a new release, but at the same time require the build-time version (headers)
# matches the run-time version (library). So to be on the safe side we hide
# the libraries too.)

./configure --prefix=$PREFIX \
      --includedir=$PREFIX/include/hdf5-1813 \
      --libdir=$PREFIX/lib/hdf5-1813 \
      --enable-production \
      --enable-debug=no \
      --disable-dependency-tracking \
      --with-zlib=$PREFIX \
      --with-szlib=no \
      --enable-filters=all \
      --enable-static=yes \
      --enable-shared=yes

make -j4
make install

# Don't ship binaries or examples; those in the regular HDF5 package work fine
rm -f $PREFIX/bin/*
rm -rf $PREFIX/share
