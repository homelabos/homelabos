# ![HomelabOS](https://gitlab.com/NickBusey/HomelabOS/raw/master/static/logo.png)

Your very own offline-first open-source data-center! Includes over 50 services!

## Beta Software Warning

This software has not reached version 1.0 and should therefore be considered unstable. While any tagged version should work well on its own, a nice friendly upgrade path from one version to another is not guaranteed.

If you like getting your hands dirty in early versions of software, this is for you. If you prefer to wait till things are stable and friendly, maybe hold off for a while.

Also, if you trash your server or wreck your data, that's on you. Test your backups. Trust nothing.

## [Documentation](https://homelabos.com/docs/)

## [Installation](https://homelabos.com/docs/setup/installation/)

## Summary

A set of Ansible scripts to configure a Docker based Homelab server with all sorts of goodies. Following the unix philosophy we gather together many specific tools to build the exact end result desired.

## Goals

To make it easy for anyone to own all their data in an easy and secure way, without the need of cloud providers.

## Features

- One command deployment `bash <(curl -s https://gitlab.com/NickBusey/HomelabOS/-/raw/dev/install_homelabos.sh)`
- Manual deployment - [Installation](https://gitlab.com/NickBusey/HomelabOS/-/blob/dev/docs/setup/installation.md)
- Automated Backups
- Easy Restore
- Automated Tor Onion Service access
- Automated HTTPS via LetsEncrypt
- [Automated Settings Sync](https://nickbusey.gitlab.io/HomelabOS/setup/installation/#syncing-settings-via-git)
- OpenVPN
- OpenLDAP
- Cloud Bastion Server with WireGuard VPN

### [Planned Features](https://gitlab.com/NickBusey/HomelabOS/issues?label_name%5B%5D=enhancement)

## [Installation Tutorial / Demo](https://youtu.be/p8cD349BGRI)

### Local Demo

If you have the latest version of Vagrant and Virtual Box setup you can demo things locally by running `make develop`. This will spin up a temporary developer copy on your local computer without needing an actual server to point things at. Note no data will actually be saved from inside the VM, so this is for testing only.

## [Available Software](https://homelabos.com/docs/#available-software)

## Requirements

A server with:

- Ubuntu 18.04 or Debian 10.3
- [Passwordless SSH via SSH keys](https://linuxconfig.org/passwordless-ssh) working.

Another computer with:

- Docker

Note: Two separate computers are not required, but are highly recommended. The idea is you have a server and then your personal computer, say a laptop or desktop. You deploy from your personal computer to the server. This way your settings are saved on your personal computer, and can be used to re-build the server and restore from backups if anything goes wrong.

## Optional Items

### Domain Name

A domain configured with a `A` type DNS record of `*.yourdomain.com` pointed at your server's IP address. (This is optional because you can use Tor to access your services without registering a domain. For best support from 3rd party clients an actual domain is highly recommended. Also certain services do not work through TOR at the moment.) Note you can hang this off a subdomain as well, so `*.homelab.yourdomain.com` will work as well.

### Port Forwarding

Ports 80 and 443 punched through any firewalls and port forwarded at your server in question. (This is also optional due to Tor access, but again highly recommended.)

### [Cloud Bastion Server](https://nickbusey.gitlab.io/HomelabOS/setup/tinc/)

Rather than pointing the domain at your home IP and having to manage DDNS, you can utilize a cloud server
to act as a bastion host via Tinc vpn and nginx.

### S3 Account

S3 is Amazon's Simple Storage Service which HomelabOS can optionally use to back up to. You can use Amazon's service, or one of many other S3 compatible providers. You can also back up to another HomelabOS instance if that other instance is running Minio, a self-hosted S3 service.

## [Installation](https://nickbusey.gitlab.io/HomelabOS/setup/installation/)

## Roadmap

* Actual OS bundle with everything pre-configured
* Web interface to enable/disable services

## Alternatives

- [Ansible NAS](https://github.com/davestephens/ansible-nas)
- [DockSTARTer](https://dockstarter.com/)

## Get Support

- [File an issue](https://gitlab.com/NickBusey/HomelabOS/issues/new?issue%5Bassignee_id%5D=&issue%5Bmilestone_id%5D=)
- [Ask a question on Reddit](https://www.reddit.com/r/HomelabOS/)
- Threaded support and development discussion on [Zulip](https://homelabos.zulipchat.com/)

## Give Support

[Become a Supporter on Patreon](https://www.patreon.com/nickbusey)

## [Contributing](https://nickbusey.gitlab.io/HomelabOS/development/contributing/)

## Watch Live Development

You can watch live development of this project on [Nick Busey's Twitch Stream](https://www.twitch.tv/nickbusey).
