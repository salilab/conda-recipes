FROM centos:6
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh && echo "0d6b23895a91294a4924bd685a3a1f48e35a17970a073cd2f684ffe2c31fc4be  Miniconda3-4.6.14-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.6.14-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.6.14-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
