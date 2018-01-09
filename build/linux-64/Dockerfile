FROM centos:6
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && echo "5551f01f436b6409d467412c33e12ecc4f43b5e029290870f8fdeca403c274e6  Miniconda3-4.3.31-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.3.31-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.3.31-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
