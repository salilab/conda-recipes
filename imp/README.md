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

Use `conda install boa` to get conda-build and mamba installed in the conda
environment.

## Building for Python 3

Download `conda_build_config.yaml` from the [conda-forge-pinning-feedstock](https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/master/recipe/conda_build_config.yaml)
and put in the home directory. Edit the `python:`, `python_impl:` and
`numpy:` sections to only include the Python versions desired (we generally
build for the two latest Python versions).

If the conda-forge IMP package has any migrations applied
(`imp-feedstock/.ci_support/migrations`) for example for new Python versions,
you may need to manually apply those to the YAML file too.

Build IMP with `conda build -c salilab imp`.

## Building for Python 2

conda-forge no longer supports Python 2, but does still retain the packages.
To build with these, first delete `$HOME/conda_build_config.yaml`, then
build IMP with `conda mambabuild -c salilab --python=2.7 imp`.

Note that `mambabuild` is like `build` but it uses `mamba` rather than `conda`
to solve dependencies. This is a **lot** faster and also seems to do a better
job of avoiding broken dependencies. (It doesn't appear to work properly on
Windows yet though.)

We only build Python 2.7 packages for Mac and Linux. On Windows it requires
using an ancient C++ compiler which fails to build big chunks of the IMP code,
and few or no users use the Python 2 Windows package anyway.

## Mac

We build for Mac in a Vagrant macOS 10.13 image.

conda-build can fail on this system during its overlinking check, due
to a broken macOS symlink:

      File "/Users/vagrant/miniforge3/lib/python3.9/site-packages/conda_build/post.py", line 1223, in check_overlinking
        return check_overlinking_impl(m.get_value('package/name'),
      File "/Users/vagrant/miniforge3/lib/python3.9/site-packages/conda_build/post.py", line 1117, in check_overlinking_impl
        with open(os.path.join(sysroot, f), 'rb') as tbd_fh:
    FileNotFoundError: [Errno 2] No such file or directory: '/System/Library/Frameworks/System.framework/System.tbd'

To work around, modify `~/miniforge3/lib/python3.9/site-packages/conda_build/post.py`
and wrap this open call to catch `FileNotFoundError` and return `lines=[]`.

## Linux

We build for Linux in the docker/podman `centos:7` container.
First run `yum install patch` to get RPMs not in the base image.

## Windows

We build for Windows in a
[Windows 10 virtual machine](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)
together with
[Build Tools for Visual Studio 2017](https://visualstudio.microsoft.com/vs/older-downloads/).
See [this blog post](https://beenje.github.io/blog/posts/how-to-setup-a-windows-vm-to-build-conda-packages/)
for more details.

Some versions of miniforge fail to install the menu entries needed to activate
conda. Work around this by running from a command prompt

    C:\Windows\System32\cmd.exe /K C:\Users\IEUser\miniforge\Scripts\activate.bat C:\Users\IEUser\miniforge

## Nightly builds

`meta.yaml` in this directory is set up to track the latest stable release,
but can be modified to make an `imp-nightly` package which tracks the most
recent nightly build (develop branch). To do so, change the `version`
and `nightly_hash` variables appropriately following the comments in this file.
