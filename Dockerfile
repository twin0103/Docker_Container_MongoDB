# imagem default
FROM centos:centos7
# Responsavel 
MAINTAINER Evandro Couto "vandocouto@gmail.com"

# Pacotes necessarios
RUN yum install vim net-tools openssh-server passwd ntpdate -y

# Criando o repositorio do MongoDB
RUN touch /etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo -e "[mongodb-org-3.2] \
\nname=MongoDB Repository \
\nbaseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/stable/x86_64/ \
\ngpgcheck=1 \
\nenabled=1 \
\ngpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc" | tee /etc/yum.repos.d/mongodb-org-3.2.repo

# Importando a chave do repositorio do MongoDB
RUN rpm --import https://www.mongodb.org/static/pgp/server-3.2.asc
RUN yum-config-manager --save --setopt=mongodb-org-3.2.skip_if_unavailable=true

# Update
RUN yum update -y

# Pacotes necessarios
RUN yum install mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools -y

# Limpando a imagem
RUN yum clean all

# ajustando o SSH
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Ajustando a data
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Definindo a senha root (Favor alterar)
RUN echo 'root:senha-aqui' | chpasswd

# Exportando LANG=C
RUN echo 'export LANG=C' >> /etc/profile 

