The `linux-64` directory contains files to set up Docker images that
can be used to build conda packages for 64-bit Linux. To build a Docker
image, use:

    sudo docker build -t conda linux-64

The `mac-setup.sh` script sets up a minimal conda environment on a real
Mac (10.6) system. It assumes the Mac has Homebrew installed, and so hides
the Homebrew packages to avoid contaminating the conda build environment.
(Really we should use a VM here, but they're a little more awkward to
set up for Mac.)
