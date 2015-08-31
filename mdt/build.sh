#!/bin/bash

HDF5_VERSION="1813"

scons -j4 prefix=$PREFIX includepath=$PREFIX/include/hdf5-$HDF5_VERSION \
          libpath=$PREFIX/lib/hdf5-$HDF5_VERSION \
          pythondir=$SP_DIR libdir=$PREFIX/lib \
          path="${PATH}" install

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
