FROM alpine:3.9

LABEL maintainer="ruidevieira@googlemail.com"

RUN apk update && \
    apk add --no-cache freetype-dev python3-dev ansible git curl gfortran build-base lapack lapack-dev zeromq zeromq-dev --virtual=blas_lapack_deps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible/
RUN touch /etc/ansible/hosts
RUN chmod 777 /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts

ARG CACHEBUST=1
RUN ln -s /usr/bin/python3 /usr/bin/python
# RUN git clone https://github.com/ruivieira/dotfiles
COPY . /dotfiles
WORKDIR /dotfiles
RUN ansible-playbook install.yml --tags "core,vim,python,jupyter"

EXPOSE 8888