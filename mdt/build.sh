#!/bin/bash

HDF5_VERSION="1107"
MODELLER_VERSION="10.2"

PYINC=`echo ${PREFIX}/include/python${PY_VER}*`

mkdir build
cd build
# Make sure we use the cmake-generated mdt_config.h, not the static version
# (used by scons builds)
rm ../src/mdt_config.h
# When building with clang builds may fail with
# ld: unknown option: -platform_version
# To work around this, add
# -DCMAKE_CXX_FLAGS="-mlinker-version=409"
# See https://stackoverflow.com/questions/61103104/ld-unknown-option-platform-version-when-building-r-packages-from-source

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_PYTHONDIR=${SP_DIR} \
      -DCMAKE_INSTALL_DATADIR=${PREFIX}/share/mdt \
      -DCMAKE_INCLUDE_PATH=${PREFIX}/include/hdf5-${HDF5_VERSION} \
      -DCMAKE_LIBRARY_PATH=${PREFIX}/lib/hdf5-${HDF5_VERSION} \
      -DPYTHON_INCLUDE_DIR=${PYINC} \
      -DCMAKE_PREFIX_PATH=${PREFIX} \
      -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
      ..

make -j4 install

if [ `uname -s` = "Darwin" ]; then
  # Fix linkage of _mdt.so to libmdt.dylib
  install_name_tool -change src/libmdt.dylib "${PREFIX}/lib/libmdt.dylib" "${SP_DIR}/_mdt.so"

  for lib in "${PREFIX}/lib/libmdt.dylib" "${SP_DIR}/_mdt.so"; do
    # Link against glib2 (and libintl dependency) bundled with Modeller, since
    # it's newer than the glib conda package
    for dep in glib-2.0.0 intl.8; do
      install_name_tool -change "@rpath/./lib${dep}.dylib" "@rpath/modeller-${MODELLER_VERSION}/lib/mac10v4/lib${dep}.dylib" ${lib}
    done
  done
fi
