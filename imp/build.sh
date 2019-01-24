#!/bin/bash

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${BUILD_PREFIX}
export CGAL_DIR=${CMAKE_PREFIX_PATH}/lib/cmake/CGAL

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

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      ${EXTRA_CMAKE_FLAGS} ..
make -j${NUMTASKS}
make install

# Remove build path from cmake files
python "${RECIPE_DIR}/remove-build-path.py" "${PREFIX}/lib/cmake/IMP/IMPConfig.cmake" "${BUILD_PREFIX}" "${PREFIX}"
