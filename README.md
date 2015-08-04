This repository contains inputs to build 'conda' packages for the
[Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/).

The resulting packages are uploaded to [Anaconda.org](http://anaconda.org/salilab/) (formerly Binstar).

In the Sali lab we build these recipes using `conda build -c salilab recipename`
for non-Python packages or
`conda build -c salilab --python=all recipename` for Python packages.
The 64-bit Linux packages are built in a Docker container (see the `build`
directory for setup info).
The 64-bit Mac packages are built on our 10.6 system.
