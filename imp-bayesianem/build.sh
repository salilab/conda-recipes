#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${BUILD_PREFIX}
export CGAL_DIR=${CMAKE_PREFIX_PATH}/lib/cmake/CGAL

# Get CMake script for out of tree build against IMP
cp "${RECIPE_DIR}/CMakeLists.txt" "${RECIPE_DIR}/UseIMP.cmake" .

# Set sensible version number
echo "master-9bd15b71" > VERSION

if [ `uname -s` = "Darwin" ]; then
  PYINC=`echo ${BUILD_PREFIX}/include/python${PY_VER}*`
  EXTRA_CMAKE_FLAGS="-DPYTHON_INCLUDE_DIR=${PYINC}"
  # Make sure the default encoding for files opened by Python 3 is UTF8
  export LANG=en_US.UTF-8
  # Help ld to find opencv libs
  export LDFLAGS="-L${BUILD_PREFIX}/lib"
  # Our Mac build system isn't that powerful; don't overload it
  NUMTASKS=2
else
  NUMTASKS=8
fi

# Don't waste time looking for a Python major version we know isn't right
if [ "${PY3K}" = "1" ]; then
  USE_PYTHON2=off
else
  USE_PYTHON2=on
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      -DUSE_PYTHON2=${USE_PYTHON2} \
      ${EXTRA_CMAKE_FLAGS} ..
make -j${NUMTASKS}
make install
