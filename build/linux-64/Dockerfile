FROM centos:5
MAINTAINER Ben Webb <ben@salilab.org>
RUN for repo in CentOS-Base libselinux; do sed -ie 's/mirrorlist/#mirrorlist/; s^#baseurl=http://mirror\.centos\.org/centos/$releasever^baseurl=http://vault.centos.org/5.11^' /etc/yum.repos.d/${repo}.repo; done
RUN yum install -y gcc-c++ make bzip2 wget openssh-clients perl.x86_64 gcc44 gcc44-c++ pkgconfig patch vim-common
RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh && echo "e9089c735b4ae53cb1035b1a97cec9febe6decf76868383292af589218304a90  Miniconda3-4.3.21-Linux-x86_64.sh" | sha256sum -c --status && bash ./Miniconda3-4.3.21-Linux-x86_64.sh -b -p /root/miniconda && rm -f Miniconda3-4.3.21-Linux-x86_64.sh && echo "export PATH=\"/root/miniconda/bin:\$PATH\"" >> /root/.bashrc
RUN source /root/.bashrc && conda update -y --all && conda install -y conda-build curl git expat openssl && conda config --add channels salilab
