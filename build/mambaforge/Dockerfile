FROM centos:7
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 curl openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN curl -L -o mambaforge.sh https://github.com/conda-forge/miniforge/releases/download/4.10.1-1/Mambaforge-4.10.1-1-Linux-x86_64.sh && echo "565f98a7c67bf045fd8ddc56699b8933f83c8c5ed8ef2d5a9c49123aec4e11c2  mambaforge.sh" | sha256sum -c --status && bash ./mambaforge.sh -b -p /root/mambaforge && rm -f mambaforge.sh && echo "export PATH=\"/root/mambaforge/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y boa curl git expat openssl
