#!/bin/sh

if [ ! -x /usr/local/bin/pkg-config ]; then
  echo "Expecting to find /usr/local/bin/pkg-config"
  exit 1
fi

CONDA_ROOT=/tmp/conda.$$

# Make sure conda build environment isn't polluted by Homebrew
(cd /usr/local && sudo mv lib lib.hide && sudo mv include include.hide && sudo mv bin bin.hide)

# Make a clean conda build environment
bash ~/Miniconda3-latest-MacOSX-x86_64.sh -b -p ${CONDA_ROOT}

# Make Homebrew pkg-config available
ln -sf /usr/local/bin.hide/pkg-config ${CONDA_ROOT}/bin

export PATH=${CONDA_ROOT}/bin:$PATH

conda install -y conda-build anaconda-client
anaconda logout # https://github.com/conda/conda/issues/3399

conda config --add channels salilab
conda update -y --all

# Make a subshell to work with conda
bash

# Clean up
rm -rf ${CONDA_ROOT}
(cd /usr/local && sudo mv lib.hide lib && sudo mv include.hide include && sudo mv bin.hide bin)
