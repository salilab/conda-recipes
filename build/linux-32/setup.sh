#!/bin/sh

CONFIG=epel-6-i386

mock -r $CONFIG --init || exit 1
mock -r $CONFIG --install gcc-c++ make bzip2 wget openssh-clients perl pkgconfig vim-common || exit 1
wget https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86.sh && echo "df552bb9046db1f4b68c048e2693dcf52f936de63481589fbaa23c4d161562cf  Miniconda3-4.3.31-Linux-x86.sh" | sha256sum -c --status || exit 1
mock -r $CONFIG --copyin Miniconda3-4.3.31-Linux-x86.sh / || exit 1
mock -r $CONFIG --chroot "bash /Miniconda3-4.3.31-Linux-x86.sh -b -p /root/miniconda && rm -f /Miniconda3-4.3.31-Linux-x86.sh" || exit 1
rm -f Miniconda3-4.3.31-Linux-x86.sh
mock -r $CONFIG --chroot 'echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /builddir/.bashrc' || exit 1
mock -r $CONFIG --chroot 'source /builddir/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab' || exit 1

echo "Use 'mock -r $CONFIG --copyin' to copy files into the mock chroot"
echo "and 'mock -r $CONFIG --shell' to get a conda shell."
echo
echo "Use 'mock -r $CONFIG --scrub=all' to clean up when you're done."
