#!/bin/bash

scons -j4 cxx="${CXX}" cxxflags="${CXXFLAGS}" prefix=${PREFIX} \
      libdir=${PREFIX}/lib includepath=${PREFIX}/include install

# install_name_tool invalidates signatures, so just remove them
# (conda should add them back at install time)
if [ `uname -m` = "arm64" ]; then
  bin=${PREFIX}/lib/libTAU.1.0.1.dylib
  mv ${bin} ${bin}.new && codesign_allocate -r -i ${bin}.new -o ${bin} && rm -f ${bin}.new || exit 1
fi
