FROM centos:5
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 gcc44 gcc44-c++ pkgconfig
RUN wget https://repo.continuum.io/miniconda/Miniconda-3.10.1-Linux-x86_64.sh && echo "363f56f5608d1552325549e7371fcf460c5ed45484eb300058e3b99c997808b5  Miniconda-3.10.1-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda-3.10.1-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda-3.10.1-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda install -y conda-build
