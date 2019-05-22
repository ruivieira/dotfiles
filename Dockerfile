FROM fedora:29
MAINTAINER Rui Vieira <ruidevieira@googlemail.com>

RUN useradd -ms /bin/bash ruivieira
RUN dnf -y groupinstall 'Development Tools'
RUN dnf install -y dnf-plugins-core file which python3 python3-devel python python-devel ansible
RUN mkdir -p /etc/ansible/
RUN touch /etc/ansible/hosts
RUN chmod 777 /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts

ARG CACHEBUST=1
RUN git clone https://github.com/ruivieira/dotfiles
WORKDIR /dotfiles
RUN ansible-playbook install.yml