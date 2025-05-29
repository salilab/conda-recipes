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

# Disable float16 support since older llvm is missing the __truncxfhf2
# function needed to convert long double to float16, causing HDF5 tests
# to fail; see also https://github.com/HDFGroup/hdf5/issues/4310

./configure --prefix=$PREFIX \
      --includedir=$PREFIX/include/hdf5-1146 \
      --libdir=$PREFIX/lib/hdf5-1146 \
      --enable-build-mode=production \
      --disable-dependency-tracking \
      --with-zlib=$PREFIX \
      --with-szlib=no \
      --enable-filters=all \
      --enable-static=yes \
      --enable-shared=yes \
      --disable-nonstandard-feature-float16

make -j4
make install

# Don't ship binaries or examples; those in the regular HDF5 package work fine
rm -f $PREFIX/bin/*
rm -rf $PREFIX/share
