#!/bin/bash

HDF5_VERSION="1813"

scons -j4 prefix=$PREFIX includepath=$PREFIX/include/hdf5-$HDF5_VERSION \
          libpath=$PREFIX/lib/hdf5-$HDF5_VERSION install
