FROM centos:7
MAINTAINER Ben Webb <benmwebb@gmail.com>
RUN yum install -y gcc-c++ make bzip2 curl openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN curl -L -o miniforge.sh https://github.com/conda-forge/miniforge/releases/download/4.10.1-1/Miniforge3-4.10.1-1-Linux-x86_64.sh && echo "224a1419c21eebe060ce656ab8a4dbd4ab92268e7c4235cb94bc4e506e323801  miniforge.sh" | sha256sum -c --status && bash ./miniforge.sh -b -p /root/miniforge && rm -f miniforge.sh && echo "export PATH=\"/root/miniforge/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl
