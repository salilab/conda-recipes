#!/bin/bash

# Find packages in Anaconda locations
export CGAL_DIR=${PREFIX}/lib/cmake/CGAL

if [ `uname -s` = "Darwin" ]; then
  PYINC=`echo ${PREFIX}/include/python${PY_VER}*`
  EXTRA_CMAKE_FLAGS="-DPYTHON_INCLUDE_DIR=${PYINC}"
  # Make sure the default encoding for files opened by Python 3 is UTF8
  export LANG=en_US.UTF-8
  # Help ld to find opencv libs
  export LDFLAGS="-L${PREFIX}/lib"
fi

# Don't waste time looking for a Python major version we know isn't right
if [ "${PY3K}" = "1" ]; then
  USE_PYTHON2=off
else
  USE_PYTHON2=on
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch \
      -G Ninja \
      -DIMP_USE_SYSTEM_RMF=on -DIMP_USE_SYSTEM_IHM=on \
      ${CMAKE_ARGS} \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      -DUSE_PYTHON2=${USE_PYTHON2} \
      ${EXTRA_CMAKE_FLAGS} ..
ninja install
