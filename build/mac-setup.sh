#!/bin/sh

if [ ! -x /usr/local/bin/pkg-config ]; then
  echo "Expecting to find /usr/local/bin/pkg-config"
  exit 1
fi

CONDA_ROOT=/tmp/conda.$$

# Make sure conda build environment isn't polluted by Homebrew
(cd /usr/local && mv lib lib.hide && mv include include.hide && mv bin bin.hide)

# Make a clean conda build environment
bash ~/Miniconda3-latest-MacOSX-x86_64.sh -b -p ${CONDA_ROOT}

# Make Homebrew pkg-config available
ln -sf /usr/local/bin.hide/pkg-config ${CONDA_ROOT}/bin

export PATH=${CONDA_ROOT}/bin:$PATH

conda install -y conda-build anaconda-client
conda config --add channels salilab
conda update -y --all

# Make a subshell to work with conda
bash

# Clean up
rm -rf ${CONDA_ROOT}
(cd /usr/local && mv lib.hide lib && mv include.hide include && mv bin.hide bin)
