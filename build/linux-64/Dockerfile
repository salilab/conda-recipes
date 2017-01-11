FROM centos:5
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 gcc44 gcc44-c++ pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a  Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.2.12-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.2.12-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
