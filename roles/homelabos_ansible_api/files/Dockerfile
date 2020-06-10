FROM python:3.8-alpine

ENV ANSIBLE_VERSION 2.9.9
RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      g++ \
      make \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python3-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
    apk add openssh-client ca-certificates sshpass && \
    \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python ; fi && \
    pip3 install --upgrade pip && \
    \
    echo "==> Installing Ansible, mitogen and API dependencies..."  && \
    pip3 install ansible==${ANSIBLE_VERSION} ansible-runner sanic sanic-cors mitogen && \
    \
    echo "==> Setting ansible defaults" && \
    mkdir -p /etc/ansible && \
    echo "[defaults]" > /etc/ansible/ansible.cfg && \
    echo "host_key_checking=False" >> /etc/ansible/ansible.cfg && \
    echo "interpreter_python=/usr/bin/python3" >> /etc/ansible/ansible.cfg && \
    echo "strategy_plugins=/usr/local/lib/python3.8/site-packages/ansible_mitogen/plugins/strategy" >> /etc/ansible/ansible.cfg && \
    echo "strategy=mitogen_linear" >> /etc/ansible/ansible.cfg && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN echo "==> Adding ansible-api and requirements" && \
    wget https://github.com/kpoppel/ansible-api/archive/master.zip && \
    unzip master.zip && \
    mv ansible-api-master ansible-api && \
    rm master.zip

WORKDIR /ansible-api

ENV API_HOST=
ENV API_ALLOW_IP=
ENV API_WS_SUB=
ENV API_TIMEOUT 3600
ENV API_WORKERS 1
ENV API_LOG_PATH /tmp/ansible-api.log
ENV API_SIGN_KEY secret
ENV API_SIGN_MODE sha256
ENV API_PORT 8765
ENV API_PLAYBOOK_PATH /playbooks/
ENV API_SCRIPT_PATH /scripts/

EXPOSE $API_PORT
VOLUME ["/playbooks","/scripts"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
