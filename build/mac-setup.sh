#!/bin/sh

CONDA_ROOT=/tmp/conda.$$

# Make sure conda build environment isn't polluted by Homebrew
(cd /usr/local && mv lib lib.hide && mv include include.hide && mv bin bin.hide)

# Make a clean conda build environment
bash ~/Miniconda-latest-MacOSX-x86_64.sh -b -p ${CONDA_ROOT}

export PATH=${CONDA_ROOT}/bin:$PATH

conda install -y conda-build anaconda-client

# Make a subshell to work with conda
bash

# Clean up
rm -rf ${CONDA_ROOT}
(cd /usr/local && mv lib.hide lib && mv include.hide include && mv bin.hide bin)
