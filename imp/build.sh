#!/bin/bash

# Find packages in Anaconda locations
export CGAL_DIR=${PREFIX}/lib/cmake/CGAL

# Make sure the default encoding for files opened by Python 3 is UTF8
export LANG=en_US.UTF-8

# Don't waste time looking for a Python major version we know isn't right
if [ "${PY3K}" = "1" ]; then
  USE_PYTHON2=off
  SYS_IHM_RMF=on
  # Don't build the scratch module
  DISABLED=scratch
else
  USE_PYTHON2=on
  # ihm and RMF aren't built for Python 2, so use those bundled with IMP instead
  SYS_IHM_RMF=off
  # Don't build the scratch module or nestor (which doesn't work with Python 2)
  DISABLED=scratch:nestor
fi

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=${DISABLED} \
      -G Ninja \
      -DIMP_USE_SYSTEM_RMF=${SYS_IHM_RMF} \
      -DIMP_USE_SYSTEM_IHM=${SYS_IHM_RMF} \
      ${CMAKE_ARGS} \
      -DUSE_PYTHON2=${USE_PYTHON2} \
      -DPython3_FIND_FRAMEWORK=NEVER \
      -DPython2_FIND_FRAMEWORK=NEVER \
      ${EXTRA_CMAKE_FLAGS} ..

# Make sure all modules we asked for were found (this is tested for
# in the final package, but quicker to abort here if they're missing)
python "${RECIPE_DIR}/check_disabled_modules.py" ${DISABLED} || exit 1

ninja install

# Don't distribute example application
rm -f ${PREFIX}/bin/imp_example_app
