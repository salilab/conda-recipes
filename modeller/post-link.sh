#!/bin/bash

config="${PREFIX}/lib/${PKG_NAME}-${PKG_VERSION}/modlib/modeller/config.py"

if [ -n "${KEY_MODELLER}" ]; then
  perl -pi -e "s/XXXX/${KEY_MODELLER}/" ${config}

else

cat > ${PREFIX}/.messages.txt <<END

Edit ${config}
and replace XXXX with your Modeller license key
(or set the KEY_MODELLER environment variable before running 'conda install').

END

fi
