FROM centos:7
MAINTAINER Ben Webb <benmwebb@gmail.com>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 pkgconfig patch vim-common
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh && echo "1314b90489f154602fd794accfc90446111514a5a72fe1f71ab83e07de9504a7  Miniconda3-py38_4.9.2-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-py38_4.9.2-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-py38_4.9.2-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
