###
##  Docker container to install HomelabOS from a container
##  Build the container like this:
##    docker build . -t homelabos_installer:latest
##
##  Run the container like this:
##    touch $HOME/.homelabos_vault_pass
##    Make sure you have SSH keys generated!
##    docker run --name homelab_installer -it -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa -v $HOME/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub -v $HOME/.homelabos_vault_pass:/root/.homelabos_vault_pass homelabos_installer:latest
##
##  Inside the container run:
##    /entrypoint.sh
##
##  You can add -e BRANCH=<branch name> if you want to noe use 'dev' as the branch.
##  Running the /entrypoint.sh script will switch to this branch first, then start the installation
##
##################
FROM ubuntu:focal

RUN apt update && \
    apt install -qy sshpass python3 python3-pip git wget && \
    pip3 install ansible docker-py mitogen

ENV BRANCH=dev

RUN git clone https://gitlab.com/NickBusey/HomelabOS.git /install
RUN echo "#!/usr/bin/bash" > /entrypoint.sh && \
    echo "git checkout ${BRANCH}" >> /entrypoint.sh && \
    echo "./setup_hlos.sh" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

WORKDIR /install/bootstrap_install
ENTRYPOINT [ "/usr/bin/bash" ]
#ENTRYPOINT [ "/entrypoint.sh" ]
