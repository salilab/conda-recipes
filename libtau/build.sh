#!/bin/bash

scons -j4 cxx="${CXX}" cxxflags="${CXXFLAGS}" prefix=${PREFIX} \
      libdir=${PREFIX}/lib includepath=${BUILD_PREFIX}/include install
