FROM centos:centos7
MAINTAINER Evandro Couto "vandocouto@gmail.com"

RUN yum install vim net-tools openssh-server passwd ntpdate -y
RUN touch /etc/yum.repos.d/mongodb-org-3.2.repo

RUN echo -e "[mongodb-org-3.2] \
\nname=MongoDB Repository \
\nbaseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/stable/x86_64/ \
\ngpgcheck=1 \
\nenabled=1 \
\ngpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc" | tee /etc/yum.repos.d/mongodb-org-3.2.repo

RUN rpm --import https://www.mongodb.org/static/pgp/server-3.2.asc
RUN yum-config-manager --save --setopt=mongodb-org-3.2.skip_if_unavailable=true
RUN yum update -y
RUN yum install mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools -y
RUN yum clean all

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN echo 'root:senha-aqui' | chpasswd
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
