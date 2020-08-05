FROM centos:6
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh && echo "879457af6a0bf5b34b48c12de31d4df0ee2f06a8e68768e5758c3293b2daf688  Miniconda3-py38_4.8.3-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-py38_4.8.3-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-py38_4.8.3-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
