#!/bin/bash

HDF5_VERSION="1813"

# Find packages in Anaconda locations
export CMAKE_PREFIX_PATH=${PREFIX}

if [ `uname -s` = "Darwin" ]; then
  PYINC=`echo ${PREFIX}/include/python${PY_VER}*`
  EXTRA_CMAKE_FLAGS="-DPYTHON_INCLUDE_DIR=${PYINC}"
else
  EXTRA_CMAKE_FLAGS=""
fi

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      -DCMAKE_INSTALL_DATADIR=${PREFIX}/share/mdt \
      -DCMAKE_INCLUDE_PATH=${PREFIX}/include/hdf5-${HDF5_VERSION} \
      -DCMAKE_LIBRARY_PATH=${PREFIX}/lib/hdf5-${HDF5_VERSION} \
      ${EXTRA_CMAKE_FLAGS} ..

make -j4 install

if [ `uname -s` = "Darwin" ]; then
  # Fix linkage of _mdt.so to libmdt.dylib
  install_name_tool -change src/libmdt.dylib "${PREFIX}/lib/libmdt.dylib" "${SP_DIR}/_mdt.so"

  for lib in "${PREFIX}/lib/libmdt.dylib" "${SP_DIR}/_mdt.so"; do
    # Link against glib2 (and libintl dependency) bundled with Modeller, since
    # it's newer than the glib conda package
    for dep in glib-2.0.0 intl.8; do
      install_name_tool -change "@rpath/./lib${dep}.dylib" "@rpath/modeller-9.15/lib/mac10v4/lib${dep}.dylib" ${lib}
    done
  done
fi
