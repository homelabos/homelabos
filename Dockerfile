# From https://github.com/walokra/docker-ansible-playbook

FROM python:3.8-alpine

ENV ANSIBLE_VERSION 2.9.9

ENV BUILD_DEPS_PACKAGES \
  gcc \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python3-dev \
  wget

ENV BUILD_PACKAGES \
  bash \
  ca-certificates \
  curl \
  git \
  jq \
  make \
  openssh-client \
  py3-dateutil \
  py3-httplib2 \
  py3-jinja2 \
  py3-paramiko \
  py3-yaml \
  sshpass \
  tar 

ENV PYTHON_PACKAGES \
  boto3 \
  docker-py \
  pyOpenSSL \
  python3-keyczar

# If installing ansible@testing
#RUN \
#    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> #/etc/apk/repositories

RUN set -x && \
  \
  echo "==> Adding build-dependencies..."  && \
  apk --update add --virtual build-dependencies ${BUILD_DEPS_PACKAGES} && \
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
  echo "==> Installing Mitogen..." && \
  pip install mitogen && \
  \
  echo "==> Installing TMV" && \
  pip install mdv && \
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
  if [ uname -m == "x86_64" ]; then key="yq_linux_amd64"; else key="yq_linux_arm64"; fi && \
  wget $(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep browser_download_url | grep $key | cut -d '"' -f 4) -O /usr/bin/yq && \
  chmod +x /usr/bin/yq

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_VAULT_PASSWORD_FILE /ansible_vault_pass
ENV ANSIBLE_CONFIG=/data/ansible.cfg
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library
ENV ANSIBLE_STRATEGY_PLUGINS=/usr/local/lib/python3.8/site-packages/ansible_mitogen/plugins/strategy
ENV ANSIBLE_STRATEGY=mitogen_linear

WORKDIR /data
