The `linux-64` directory contains files to set up Docker images that
can be used to build conda packages for 64-bit Linux. To build a Docker
image, use:

    sudo docker build -t conda linux-64

The `mac-setup.sh` script sets up a minimal conda environment on a real
Mac (10.6) system. It assumes the Mac has Homebrew installed, and so hides
the Homebrew packages to avoid contaminating the conda build environment.
(Really we should use a VM here, but they're a little more awkward to
set up for Mac.)

The `linux-32` directory contains the commands we run to set up a `mock`
chroot that can be used to build conda packages for 32-bit Linux.

The Windows packages are built in a Windows VM with Visual Studio 2010 Express
installed. To reproduce this environment, download [MSVS 2010](http://download.microsoft.com/download/1/E/5/1E5F1C0A-0D5B-426A-A603-1798B951DDAE/VS2010Express1.iso)
then install and register it (get a license key from Microsoft). Then just
use the provided Start menu item to get an environment for building 32-bit
packages.

For 64-bit,
next download the [x64 SDK ISO](http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso) and install that. Then
apply the MSVS 2010 SP1 update. This breaks the SDK, so finally fix that by
applying [KB2519277](https://support.microsoft.com/en-us/kb/2519277). To get
an environment suitable for building the packages, run
`setenv /xp /x64 /release`.
