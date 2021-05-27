# Building IMP conda packages

We use [conda-forge](https://conda-forge.org/) to provide dependencies
(we used to use the Anaconda defaults channel but we found we had to build
or rebuild too many packages in the salilab channel, particularly for
newer Python or for Windows).

## conda distribution

We use a [miniforge](https://github.com/conda-forge/miniforge/releases)
distribution on each build platform. We find that conda often gets confused
(generates incorrect dependencies, particularly when switching between Python
2 and Python 3) so we generally install a fresh copy for each build.

## Building for Python 3

Download `conda_build_config.yaml` from the [conda-forge-pinning-feedstock](https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/master/recipe/conda_build_config.yaml)
and put in the home directory. Edit the `python:`, `python_impl:` and
`numpy:` sections to only include the Python versions desired (we generally
build for the two latest Python versions).

Build IMP with `conda build -c salilab imp-nightly`.

## Building for Python 2

conda-forge no longer supports Python 2, but does still retain the packages.
To build with these, first delete `$HOME/conda_build_config.yaml`, then
Build IMP with `conda build -c salilab --python=2.7 imp-nightly`.

We only build Python 2.7 packages for Mac and Linux. On Windows it requires
using an ancient C++ compiler which fails to build big chunks of the IMP code.

## Mac/Linux

We build for Mac or Linux on a stock macOS or Fedora box.

## Windows

We build for Windows in a
[Windows 10 virtual machine](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)
together with
[Build Tools for Visual Studio 2017](https://visualstudio.microsoft.com/vs/older-downloads/).
See [this blog post](https://beenje.github.io/blog/posts/how-to-setup-a-windows-vm-to-build-conda-packages/)
for more details.

## Nightly builds

`meta.yaml` in this directory tracks the latest stable release, and needs
to be modified to make nightly builds.
