#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname -s` = "Darwin" ]; then
  # -stdlib=libc++ is not compatible with 10.6 (and Anaconda dropped support
  # for 10.6 anyway)
  export MACOSX_DEPLOYMENT_TARGET=10.7
  PYINC=`echo ${PREFIX}/include/python${PY_VER}*`
  # Use clang and libc++ library otherwise linking against Boost libraries
  # will fail
  EXTRA_CMAKE_FLAGS="\
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DPYTHON_INCLUDE_DIR=${PYINC}"
  # Make sure the default encoding for files opened by Python 3 is UTF8
  export LANG=en_US.UTF-8
  # Help ld to find opencv libs; use clang++
  export LDFLAGS="-L${PREFIX}/lib -stdlib=libc++"
  export CXXFLAGS="-std=c++11 -stdlib=libc++"
  NCPU=$(sysctl -n hw.ncpu)
else
  NCPU=4
  EXTRA_CMAKE_FLAGS=""
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      ${EXTRA_CMAKE_FLAGS} ..
make -j${NCPU}
make install
