This repository contains inputs to build 'conda' packages for the
[Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/).

The resulting packages are uploaded to [Anaconda.org](https://anaconda.org/salilab/) (formerly Binstar).

In the Sali lab we build these recipes using `conda build -c salilab recipename`
for non-Python packages or
`conda build -c salilab --python=all recipename` for Python packages.

 - 64-bit Linux packages are built in a CentOS 5 Docker container
   (see the `build` directory for the Docker configuration used).
 - 32-bit Linux packages are built in a CentOS 5 `mock` environment
   (see the `build` directory for a setup script).
 - 64-bit Mac packages are built on our 10.9 system (see the `build`
   directory for our setup script).
 - 32-bit Windows packages are built in a 32-bit Windows 7 VM with
   Visual Studio Express installed (see the `build` directory for
   setup info).
 - 64-bit Windows packages are built in a 64-bit Windows 7 VM with
   Visual Studio Express installed (see the `build` directory for
   setup info).
