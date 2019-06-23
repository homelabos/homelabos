# From https://github.com/walokra/docker-ansible-playbook

FROM python:3.7.3-alpine

ENV ANSIBLE_VERSION 2.6.1

ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
  make \
  py3-dateutil \
  py3-httplib2 \
  py3-jinja2 \
  py3-paramiko \
  py3-yaml \
  ca-certificates

ENV PYTHON_PACKAGES \
  python3-keyczar \
  boto3 \
  docker-py

# If installing ansible@testing
#RUN \
#    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> #/etc/apk/repositories

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      jq \
      python3-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
    \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python ; fi && \
    pip install --upgrade pip && \
    pip install ${PYTHON_PACKAGES} && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    \
    echo "==> Installing necessities..."  && \
    wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip && \
    unzip terraform_0.12.0_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    wget https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 && \
    chmod +x yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin && \
    wget https://gitlab.com/NickBusey/HomelabOS/-/archive/master/HomelabOS-master.zip && \
    unzip HomelabOS-master.zip && \
    mv HomelabOS-master HomelabOS

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /data
