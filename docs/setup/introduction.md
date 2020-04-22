# Introduction to HomelabOS

## What does HomelabOS actually do?

HomelabOS deploys web services via docker-compose files that are controlled by systemd.

## How does it do it?

Ansible templates out the HomelabOS config file using Jinja2 templating, which is then used to deploy HomelabOS itself.

It uses a combination of a Makefile, several bash scripts, and ansible playbooks to get everything done.

## Why does it do it that way?

Through much trial and error we have ended up on this configuration, but we are always more than happy to discuss better ways to do things. Please open an issue on GitLab, submit a topic to Reddit, or join us on the chat.
