#!/bin/bash

if [ `uname -s` = "Darwin" ]; then
  EXTRA_CMAKE_OPTS="-DWITH_OPENCL=OFF"
else
  EXTRA_CMAKE_OPTS="\
    -DCMAKE_CXX_COMPILER=/usr/bin/g++44                             \
    -DCMAKE_C_COMPILER=/usr/bin/gcc44 "
fi

mkdir build
cd build
cmake                                                               \
    ${EXTRA_CMAKE_OPTS}                                             \
    -DWITH_PYTHON=OFF                                               \
    -DCMAKE_INSTALL_PREFIX=$PREFIX                                  \
    -DWITH_CUDA=OFF                                                 \
    -DWITH_AVFOUNDATION=OFF                                         \
    -DWITH_FFMPEG=OFF                                               \
    -DJPEG_INCLUDE_DIR:PATH=$PREFIX/include                         \
    -DJPEG_LIBRARY:FILEPATH=$PREFIX/lib/libjpeg.so                  \
    -DPNG_PNG_INCLUDE_DIR:PATH=$PREFIX/include                      \
    -DPNG_LIBRARY:FILEPATH=$PREFIX/lib/libpng.so                    \
    -DZLIB_INCLUDE_DIR:PATH=$PREFIX/include                         \
    -DZLIB_LIBRARY:FILEPATH=$PREFIX/lib/libz.so                     \
    ..
make
make install
