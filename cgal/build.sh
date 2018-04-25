#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname` == Darwin ]; then
    cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D CMAKE_BUILD_TYPE=Release \
    -D MPFR_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D MPFR_LIBRARIES=$BUILD_PREFIX/lib/libmpfr.a \
    -D GMP_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D GMP_LIBRARIES=$BUILD_PREFIX/lib/libgmp.dylib \
    -D GMP_LIBRARIES_DIR=$BUILD_PREFIX/lib \
    -D GMPXX_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D GMPXX_LIBRARIES=$BUILD_PREFIX/include/libgmpxx.dylib \
    -D ZLIB_LIBRARY=$BUILD_PREFIX/lib/libz.dylib \
    -D ZLIB_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D WITH_OpenGL=/System/Library/Frameworks/OpenGL.framework/ \
    -D OPENGL_INCLUDE_DIR=/System/Library/Frameworks/OpenGL.framework/Headers \
    .
else
    export CXXFLAGS="-fPIC"
    cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_LIBDIR=lib \
    -D BOOST_ROOT=$BUILD_PREFIX \
    -D BOOST_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D MPFR_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D MPFR_LIBRARIES=$BUILD_PREFIX/lib/libmpfr.so \
    -D GMP_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D GMP_LIBRARIES=$BUILD_PREFIX/lib/libgmp.so \
    -D GMP_LIBRARIES_DIR=$BUILD_PREFIX/lib \
    -D GMPXX_INCLUDE_DIR=$BUILD_PREFIX/include \
    -D GMPXX_LIBRARIES=$BUILD_PREFIX/include/libgmpxx.so \
    -D ZLIB_LIBRARY=$BUILD_PREFIX/lib/libz.so \
    -D ZLIB_INCLUDE_DIR=$BUILD_PREFIX/include \
    -DBUILD_SHARED_LIBS=FALSE \
    .
fi


make
make install
