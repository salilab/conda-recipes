#!/bin/bash

mkdir -vp ${PREFIX}/bin;

if [ `uname` == Darwin ]; then
    ./bootstrap.sh \
      --without-libraries=python \
      --prefix="${PREFIX}/" --libdir="${PREFIX}/lib/boost-mac" \
      --includedir="${PREFIX}/include/boost-mac" \
      | tee bootstrap.log 2>&1

    ./b2 \
      variant=release address-model=64 architecture=x86 \
      threading=multi link=shared \
      -j$(sysctl -n hw.ncpu) \
      install | tee b2.log 2>&1
fi
