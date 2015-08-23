This repository contains inputs to build 'conda' packages for the
[Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/).

The resulting packages are uploaded to [Anaconda.org](http://anaconda.org/salilab/) (formerly Binstar).

In the Sali lab we build these recipes using `conda build -c salilab recipename`
for non-Python packages or
`conda build -c salilab --python=all recipename` for Python packages.

 - 64-bit Linux packages are built in a Docker container (see the `build`
   directory for the Docker configuration used).
 - 64-bit Mac packages are built on our 10.6 system (see the `build`
   directory for our setup script).
 - 32-bit Windows packages are built in a 32-bit Windows XP VM with
   Visual Studio Express 2010 SP1 installed (see the `build` directory for
   setup info).
 - 64-bit Windows packages are built in a 64-bit Windows 7 VM with
   Visual Studio Express 2010 SP1 and the Windows 7 SDK installed
   (see the `build` directory for setup info).
