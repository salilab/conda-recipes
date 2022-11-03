This repository contains inputs to build 'conda' packages for the
[Anaconda Python distribution](https://www.anaconda.com/products/distribution).

The resulting packages are uploaded to [Anaconda.org](https://anaconda.org/salilab/) (formerly Binstar).

In the Sali lab we build these recipes using `conda build -c salilab recipename`.

 - 64-bit Linux packages are built in a CentOS 7 Docker container
   (see the `build` directory for the Docker configuration used).
 - 32-bit Linux packages are built in a CentOS 6 `mock` environment
   (see the `build` directory for a setup script).
 - 64-bit Intel Mac packages are built in a 10.13 Intel VM.
 - ARM64 Mac packages are built in a 12.1 ARM64 VM.
 - 32-bit Windows packages are built in a 32-bit Windows 7 VM with
   Visual Studio Express 2010 installed (see the `build` directory for
   setup info).
 - 64-bit Windows packages are built in a 64-bit Windows 7 VM with
   Visual Studio Express 2012 installed (see the `build` directory for
   setup info).
 - 64-bit Windows packages for Python 3.9 or later are built in a 64-bit
   Windows 10 VM with Visual Studio Express 2012 installed.
