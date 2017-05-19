#!/bin/bash

modtop="${PREFIX}/lib/${PKG_NAME}-${PKG_VERSION}"
config="${modtop}/modlib/modeller/config.py"

if [ -n "${KEY_MODELLER}" ]; then

cat > "${config}" <<END
install_dir = r'${modtop}'
license = r'${KEY_MODELLER}'
END

else

cat >> ${PREFIX}/.messages.txt <<END

Edit ${config}
and replace XXXX with your Modeller license key
(or set the KEY_MODELLER environment variable before running 'conda install').

END

fi
