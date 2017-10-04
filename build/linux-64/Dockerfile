FROM centos:6
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.3.27.1-Linux-x86_64.sh && echo "640f505f06f87d75bebc629e4a677ebb185ea9a34eb6d7c199db0753ffc42f62  Miniconda3-4.3.27.1-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.3.27.1-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.3.27.1-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
