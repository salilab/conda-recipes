#!/bin/bash

modtop=${PREFIX}/lib/${PKG_NAME}-${PKG_VERSION}

if [ `uname -s` = "Darwin" ]; then
  tar -xzf *.pax.gz
  mkdir -p ${PREFIX}/lib
  # Fix broken HDF5 symlinks in 9.15 package (fixed in SVN)
  (cd Library/modeller-*/lib/mac10v4 && rm -f libhdf5.dylib libhdf5_hl.dylib && ln -sf libhdf5.8.dylib libhdf5.dylib && ln -sf libhdf5_hl.8.dylib libhdf5_hl.dylib)

  # Move from .dmg location to Anaconda path
  mv Library/modeller* ${PREFIX}/lib

  # Change library paths accordingly
  exetype="mac10v4-intel64"
  univ_exetype="mac10v4"
  libs="ifcore imf irc svml intlc glib-2.0.0 intl.8 hdf5.8 hdf5_hl.8 saxs modeller.10"
  for lib in ${libs}; do
    install_name_tool -id ${modtop}/lib/${univ_exetype}/lib${lib}.dylib \
                          ${modtop}/lib/${univ_exetype}/lib${lib}.dylib
  done
  for bin in ${modtop}/bin/mod*_* ${modtop}/lib/${univ_exetype}/*.{dylib,so}; do
    for lib in ${libs}; do
      install_name_tool -change /Library/${PKG_NAME}-${PKG_VERSION}/lib/${univ_exetype}/lib${lib}.dylib ${modtop}/lib/${univ_exetype}/lib${lib}.dylib ${bin}
    done
  done

  # Have modXXX find the _modeller.so built against the system Python
  mkdir ${modtop}/syspython
  mv ${modtop}/lib/mac10v4/_modeller.so ${modtop}/syspython
  perl -pi -e "s#^exec#export PYTHONPATH=${modtop}/syspython\\nexec#" ${modtop}/bin/mod${PKG_VERSION}

else
  if [ "${ARCH}" = "64" ]; then
    exetype="x86_64-intel8"
  else
    exetype="i386-intel8"
  fi
  /bin/echo -e "\n${modtop}\nXXXX\n\n\n\n" | ./Install

  # Have modXXX find the _modeller.so built against the bundled Python (2.3)
  mkdir ${modtop}/syspython
  mv ${modtop}/lib/${exetype}/_modeller.so ${modtop}/syspython
  perl -pi -e "s#^exec#export PYTHONPATH=${modtop}/syspython\\nexec#" ${modtop}/bin/mod${PKG_VERSION}

  # Remove other Python versions (we'll build one later on in the script)
  rm -rf ${modtop}/lib/${exetype}/python*.*

  # Don't need modpy.sh
  rm -f ${modtop}/bin/modpy.sh

fi

# Bundle glib so we don't need it as a runtime dependency (since it pulls in
# gettext which might interfere with the system copy)
if [ `uname -s` = "Darwin" ]; then
  cp ${PREFIX}/lib/libglib-2.0.dylib ${modtop}/lib/${exetype}/
else
  cp ${PREFIX}/lib/{libintl.so.8,libglib-2.0.so.0} ${modtop}/lib/${exetype}/
fi

mv ${modtop}/bin/mod${PKG_VERSION} ${PREFIX}/bin
perl -pi -e "s#^MODINSTALL(.*)=.*#MODINSTALL\$1=/opt/anaconda1anaconda2anaconda3/lib/${PKG_NAME}-${PKG_VERSION}#" ${PREFIX}/bin/mod${PKG_VERSION}

# Put pure Python interface in the standard search paths
ln -s ${modtop}/modlib/modeller ${SP_DIR}

perl -pi -e "s/^exetype =.*$/exetype = \"${exetype}\"/" \
         ${modtop}/src/swig/setup.py

# to fix upstream: setup.py doesn't currently work with Python 3
py_major=`echo ${PY_VER} | cut -b1`
if [ "${py_major}" = "3" ]; then
  perl -pi -e 's/import commands/import subprocess/;' \
           -e 's/for token in.*$/for token in subprocess.check_output(["pkg-config", "--libs", "--cflags"] + list(packages), universal_newlines=True).split():/;' \
           -e 's/^.*join\(packages\).*$//;' \
           ${modtop}/src/swig/setup.py
fi

# Build Python extension from SWIG inputs
cd ${modtop}/src/swig
swig -python -keyword -nodefaultctor -nodefaultdtor -noproxy modeller.i
python setup.py build
cp build/lib.*${PY_VER}/_modeller*.so ${SP_DIR}
rm -rf build modeller_wrap.c

# Make config.py
cat > ${modtop}/modlib/modeller/config.py <<END
install_dir = r'${modtop}'
license = r'XXXX'
END

if [ `uname -s` = "Darwin" ]; then
  # Building _modeller.so pulled in glib and libintl from Homebrew; point to
  # bundled copies instead (better would be to have packages for these in
  # Anaconda)
  install_name_tool -change /usr/local/lib/libglib-2.0.0.dylib ${modtop}/lib/${univ_exetype}/libglib-2.0.0.dylib ${SP_DIR}/_modeller.so
  install_name_tool -change /usr/local/opt/gettext/lib/libintl.8.dylib ${modtop}/lib/${univ_exetype}/libintl.8.dylib ${SP_DIR}/_modeller.so

  # Make sure that binaries don't refer to non-standard libs (e.g. in Homebrew) 
  otool -L ${SP_DIR}/_modeller.so ${modtop}/lib/${univ_exetype}/*.dylib ${modtop}/bin/mod*_* | grep -Ev "/usr/lib|/lib/${univ_exetype}/|/System/Library/|:" | sort -u > /tmp/non-standard.$$
  if [ -s /tmp/non-standard.$$ ]; then
    echo "Non-standard libraries linked against:"
    cat /tmp/non-standard.$$
    rm -f /tmp/non-standard.$$
    exit 1
  else
    rm -f /tmp/non-standard.$$
  fi
fi

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
