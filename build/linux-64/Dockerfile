FROM centos:5
MAINTAINER Ben Webb <ben@salilab.org>
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 gcc44 gcc44-c++ pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh && echo "b9fe70ce7b6fa8df05abfb56995959b897d0365299f5046063bc236843474fb8  Miniconda3-4.3.11-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.3.11-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.3.11-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
