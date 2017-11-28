#!/bin/bash

set -e

# Link dynamically
perl -pi -e 's/\-static //' makefile

echo "DEST_DIR=${PREFIX}" > make.config
echo "MAN_DIR=${PREFIX}/share/man/man1" >> make.config

if [ `uname -s` = "Darwin" ]; then
  # Note that this can't work right now because DSSP needs C++0x
  # and libc++, but the conda Boost package is linked against the
  # legacy libstdc++ library
  echo "BOOST_INC_DIR=${PREFIX}/include/boost-mac" >> make.config
  echo "BOOST_LIB_DIR=${PREFIX}/lib/boost-mac" >> make.config
  perl -pi -e "s#^(CFLAGS.*)#\$1 -I${PREFIX}/include#" makefile
  perl -pi -e "s#^(LDOPTS.*)#\$1 -L${PREFIX}/lib#" makefile
else
  echo "BOOST_INC_DIR=${PREFIX}/include" >> make.config
  echo "BOOST_LIB_DIR=${PREFIX}/lib" >> make.config
  # Need support for C++0x
  perl -pi -e 's/^CXX.*/CXX=g++ -std=c++0x/' makefile
fi

make -j4 install
