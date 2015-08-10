#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname -s` = "Darwin" ]; then
  PYINC=`echo ${PREFIX}/include/python${PY_VER}*`
  EXTRA_CMAKE_FLAGS="\
      -DCMAKE_INCLUDE_PATH=${PREFIX}/include/boost-mac \
      -DCMAKE_LIBRARY_PATH=${PREFIX}/lib/boost-mac \
      -DPYTHON_INCLUDE_DIR=${PYINC}"
  # Make sure the default encoding for files opened by Python 3 is UTF8
  export LANG=en_US.UTF-8
  # Help ld to find opencv libs
  export LDFLAGS="-L${PREFIX}/lib"
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
