#!/bin/bash

set -e

# Link dynamically
perl -pi -e 's/\-static //' makefile

echo "DEST_DIR=${PREFIX}" > make.config
echo "MAN_DIR=${PREFIX}/share/man/man1" >> make.config
echo "BOOST_INC_DIR=${PREFIX}/include" >> make.config
echo "BOOST_LIB_DIR=${PREFIX}/lib" >> make.config

make -j4 install
