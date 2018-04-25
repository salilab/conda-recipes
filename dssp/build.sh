#!/bin/bash

set -e

# Link dynamically
perl -pi -e 's/\-static //' makefile

echo "DEST_DIR=${PREFIX}" > make.config
echo "MAN_DIR=${PREFIX}/share/man/man1" >> make.config

echo "BOOST_INC_DIR=${BUILD_PREFIX}/include" >> make.config
echo "BOOST_LIB_DIR=${BUILD_PREFIX}/lib" >> make.config
# Use conda-provided cxx
perl -pi -e 's/^CXX/#CXX/' makefile

# clang++ won't find std::tuple unless in C++11 mode
if [ `uname -s` = "Darwin" ]; then
  CFLAGS="-std=c++11 ${CFLAGS}"
fi

make -j4 install
