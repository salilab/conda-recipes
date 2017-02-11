#!/bin/bash

# cmake looks in <incdir>/libpng, not <incdir>/libpng16, so make a symlink
mkdir pnginclude
ln -sf "$PREFIX/include/libpng16" pnginclude/libpng

if [ `uname -s` = "Darwin" ]; then
  EXTRA_CMAKE_OPTS="-DWITH_OPENCL=OFF"
  EXTRA_MAKE_OPTS="-j2"
  SO="dylib"
  perl -pi -e "s#INSTALL_NAME_DIR lib#INSTALL_NAME_DIR ${PREFIX}/lib#" cmake/OpenCVModule.cmake apps/traincascade/CMakeLists.txt apps/haartraining/CMakeLists.txt
else
  export LD_LIBRARY_PATH=$PREFIX/lib
  EXTRA_CMAKE_OPTS="\
    -DCMAKE_CXX_COMPILER=/usr/bin/g++44                             \
    -DCMAKE_C_COMPILER=/usr/bin/gcc44 "
  EXTRA_MAKE_OPTS="-j4"
  SO="so"
fi

mkdir build
cd build
cmake                                                               \
    ${EXTRA_CMAKE_OPTS}                                             \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_opencv_python=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_ZLIB=OFF \
    -DWITH_JASPER=OFF \
    -DPNG_PNG_INCLUDE_DIR=`pwd`/../pnginclude \
    -DCMAKE_INSTALL_PREFIX=$PREFIX                                  \
    -DWITH_CUDA=OFF                                                 \
    -DWITH_AVFOUNDATION=OFF                                         \
    -DWITH_FFMPEG=OFF                                               \
    -DJPEG_INCLUDE_DIR:PATH=$PREFIX/include                         \
    -DJPEG_LIBRARY:FILEPATH=$PREFIX/lib/libjpeg.${SO}               \
    -DPNG_LIBRARY:FILEPATH=$PREFIX/lib/libpng.${SO}                 \
    -DZLIB_INCLUDE_DIR:PATH=$PREFIX/include                         \
    -DZLIB_LIBRARY:FILEPATH=$PREFIX/lib/libz.${SO}                  \
    ..
make ${EXTRA_MAKE_OPTS}
make install
