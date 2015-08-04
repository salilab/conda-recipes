#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname` == Darwin ]; then
    cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D BOOST_ROOT=$PREFIX \
    -D BOOST_INCLUDE_DIR=$PREFIX/include \
    -D MPFR_INCLUDE_DIR=$PREFIX/include \
    -D MPFR_LIBRARIES=$PREFIX/lib/libmpfr.dylib \
    -D GMP_INCLUDE_DIR=$PREFIX/include \
    -D GMP_LIBRARIES=$PREFIX/lib/libgmp.dylib \
    -D GMP_LIBRARIES_DIR=$PREFIX/lib \
    -D GMPXX_INCLUDE_DIR=$PREFIX/include \
    -D GMPXX_LIBRARIES=$PREFIX/include/libgmpxx.dylib \
    -D ZLIB_LIBRARY=$PREFIX/lib/libz.dylib \
    -D ZLIB_INCLUDE_DIR=$PREFIX/include \
    -D WITH_OpenGL=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/OpenGL.framework/ \
	-D OPENGL_INCLUDE_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/OpenGL.framework/Headers \
    .
else
    cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D BOOST_ROOT=$PREFIX \
    -D BOOST_INCLUDE_DIR=$PREFIX/include \
    -D MPFR_INCLUDE_DIR=$PREFIX/include \
    -D MPFR_LIBRARIES=$PREFIX/lib/libmpfr.so \
    -D GMP_INCLUDE_DIR=$PREFIX/include \
    -D GMP_LIBRARIES=$PREFIX/lib/libgmp.so \
    -D GMP_LIBRARIES_DIR=$PREFIX/lib \
    -D GMPXX_INCLUDE_DIR=$PREFIX/include \
    -D GMPXX_LIBRARIES=$PREFIX/include/libgmpxx.so \
    -D ZLIB_LIBRARY=$PREFIX/lib/libz.so \
    -D ZLIB_INCLUDE_DIR=$PREFIX/include \
    .
fi


make
make install
