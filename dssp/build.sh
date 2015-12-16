#!/bin/bash

set -e

# Link dynamically
perl -pi -e 's/\-static //' makefile

echo "DEST_DIR=${PREFIX}" > make.config
echo "MAN_DIR=${PREFIX}/share/man/man1" >> make.config

if [ `uname -s` = "Darwin" ]; then
  echo "BOOST_INC_DIR=${PREFIX}/include/boost-mac" >> make.config
  echo "BOOST_LIB_DIR=${PREFIX}/lib/boost-mac" >> make.config
  perl -pi -e "s#^(CFLAGS.*)#\$1 -I${PREFIX}/include#" makefile
  perl -pi -e "s#^(LDOPTS.*)#\$1 -L${PREFIX}/lib#" makefile
else
  echo "BOOST_INC_DIR=${PREFIX}/include" >> make.config
  echo "BOOST_LIB_DIR=${PREFIX}/lib" >> make.config
fi

make -j4 install
