#!/bin/sh

CONFIG=epel-5-i386

mock -r $CONFIG --init || exit 1
mock -r $CONFIG --install gcc-c++ make bzip2 wget openssh-clients perl gcc44 gcc44-c++ pkgconfig vim-common || exit 1
wget https://repo.continuum.io/miniconda/Miniconda-3.10.1-Linux-x86.sh && echo "509ee56f1590705472fdac4a00aa7191f79a6a09daf4af088e92f93c648d815e  Miniconda-3.10.1-Linux-x86.sh" | sha256sum -c --status || exit 1
mock -r $CONFIG --copyin Miniconda-3.10.1-Linux-x86.sh / || exit 1
mock -r $CONFIG --chroot "bash /Miniconda-3.10.1-Linux-x86.sh -b -p /root/miniconda && rm -f /Miniconda-3.10.1-Linux-x86.sh" || exit 1
rm -f Miniconda-3.10.1-Linux-x86.sh
mock -r $CONFIG --chroot 'echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /builddir/.bashrc' || exit 1
mock -r $CONFIG --chroot 'source /builddir/.bashrc && conda update -y --all && conda install -y conda-build && conda config --add channels salilab' || exit 1

echo "Use 'mock -r $CONFIG --copyin' to copy files into the mock chroot"
echo "and 'mock -r $CONFIG --shell' to get a conda shell."
echo
echo "Use 'mock -r $CONFIG --scrub=all' to clean up when you're done."
