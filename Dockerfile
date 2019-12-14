FROM alpine:3.9

LABEL maintainer="ruidevieira@googlemail.com"

# RUN adduser -s /bin/bash -D ruivieira

RUN mkdir -p /etc/ansible/
RUN touch /etc/ansible/hosts
RUN chmod 777 /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts

RUN mkdir -p /home/root/dotfiles


# USER ruivieira

COPY . /root/dotfiles

WORKDIR /root/dotfiles

RUN apk --no-cache add ansible git ttyd

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN ansible-playbook install.yml --tags "core"

CMD ["/usr/bin/ttyd", "-p", "8080", "/bin/zsh"]