FROM docker:dind
RUN mkdir $HOME/.ssh

RUN apk add python3 python3-dev gcc g++ libffi-dev openssl-dev bash bash-completion
RUN pip3 install --upgrade pip && \
    pip3 install ansible

RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd && \
    echo 'alias l="ls -lah --color=auto"' >> ~/.bash_profile && \
    ansible-galaxy install giovtorres.bash-completion && \
    echo 'PS1="\[\e[1;32m\]\u@\h:\[\e[0m\]\w\[\e[1;32m\]$ \[\e[0m\]"' >> ~/.bashrc

ADD ./workdir/ansible.cfg /root/.ansible.cfg

EXPOSE 22
WORKDIR /ansible
CMD ["tail","-f","/dev/null"]
