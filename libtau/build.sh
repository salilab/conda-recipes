#!/bin/bash

if [ `uname -s` = "Darwin" ]; then
  tau_lib="Mac10.6.x86_64"
else
  if [ "${ARCH}" = "64" ]; then
    tau_lib="RedHat5.x86_64"
  else
    tau_lib="RedHat5.i386"
  fi
fi

mkdir -p ${PREFIX}/lib ${PREFIX}/include/libTAU
cp lib/${tau_lib}/libTAU.* ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/libTAU/

if [ `uname -s` = "Darwin" ]; then
  ln -sf libTAU.1.dylib ${PREFIX}/lib/libTAU.dylib
else
  ln -sf libTAU.so.1 ${PREFIX}/lib/libTAU.so
fi
