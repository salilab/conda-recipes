#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname -s` = "Darwin" ]; then
  EXTRA_CMAKE_FLAGS="\
      -DCMAKE_INCLUDE_PATH=${PREFIX}/include/boost-mac \
      -DCMAKE_LIBRARY_PATH=${PREFIX}/lib/boost-mac \
      -DPYTHON_INCLUDE_DIR=${PREFIX}/include/python${PY_VER}"
else
  EXTRA_CMAKE_FLAGS=""
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      ${EXTRA_CMAKE_FLAGS} ..
make -j4
make install
