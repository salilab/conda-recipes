#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname -s` = "Darwin" ]; then
  PYINC=`echo ${PREFIX}/include/python${PY_VER}*`
  # Can't build in c++11 mode yet, since Boost is built without it
  EXTRA_CMAKE_FLAGS="\
    -DPYTHON_INCLUDE_DIR=${PYINC} \
    -DIMP_CXX11=OFF"
  # Make sure the default encoding for files opened by Python 3 is UTF8
  export LANG=en_US.UTF-8
  # Help ld to find opencv libs
  export LDFLAGS="-L${PREFIX}/lib"
  # Our Mac build system isn't that powerful; don't overload it
  NUMTASKS=2
else
  # gcc 4.1 and newer Boost (flat_set and flat_map) don't work well together
  # (RMF ends up not being able to write files out correctly)
  EXTRA_CMAKE_FLAGS="\
    -DCMAKE_CXX_COMPILER=/usr/bin/g++44 \
    -DCMAKE_C_COMPILER=/usr/bin/gcc44"
  NUMTASKS=4
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      ${EXTRA_CMAKE_FLAGS} ..
make -j${NUMTASKS}
make install
