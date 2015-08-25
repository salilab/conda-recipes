#!/bin/bash

./configure --prefix="${PREFIX}"
make
make install

# Put headers in regular location
mkdir -p "${PREFIX}/include/"
mv "${PREFIX}"/lib/libffi-3.2.1/include/*.h "${PREFIX}/include/"
rm -rf "${PREFIX}/lib/libffi-3.2.1"
