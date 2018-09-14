FROM centos:6
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh && echo "ea4594241e13a2671c5b158b3b813f0794fe58d514795fbf72a1aad24db918cf  Miniconda3-4.5.11-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.5.11-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.5.11-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
