FROM docker:dind

WORKDIR /root
RUN mkdir $HOME/.ssh

RUN apk add python3 python3-dev gcc g++ libffi-dev openssl-dev \
    bash bash-completion curl
RUN pip3 install --upgrade pip && \
    pip3 install ansible awscli

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh

RUN apk add --no-cache --virtual=build-deps wget \
  && wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && apk del build-deps

RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd && \
    echo 'alias l="ls -lah --color=auto"' >> ~/.bashrc && \
    ansible-galaxy install giovtorres.bash-completion && \
    echo 'PS1="\[\e[1;32m\]\u@\h:\[\e[0m\]\w\[\e[1;32m\]$ \[\e[0m\]"' >> ~/.bashrc

ADD ./workdir/ansible.cfg /root/.ansible.cfg

EXPOSE 22
WORKDIR /ansible
CMD ["tail","-f","/dev/null"]
