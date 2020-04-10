# ![HomelabOS](https://gitlab.com/NickBusey/HomelabOS/raw/master/static/logo.png)

Your very own offline-first open-source data-center! Includes over 50 services!

## Beta Software Warning

This software has not reached version 1.0 and should therefore be considered unstable. While any tagged version should work well on its own, a nice friendly upgrade path from one version to another is not guaranteed.

If you like getting your hands dirty in early versions of software, this is for you. If you prefer to wait till things are stable and friendly, maybe hold off for a while.

Also, if you trash your server or wreck your data, that's on you. Test your backups. Trust nothing.

## [Documentation](https://gitlab.com/NickBusey/HomelabOS/-/tree/dev/docs)

## [Installation](https://gitlab.com/NickBusey/HomelabOS/-/blob/dev/docs/setup/installation.md#installation)

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

## Available Software

### Categories

  - [Analytics](#analytics)
  - [Automation](#automation)
  - [Blogging Platforms](#blogging-platforms)
  - [Calendaring and Contacts Management](#calendaring-and-contacts-management)
  - [Chat](#chat)
  - [Document Management](#document-management)
  - [E-books](#e-books)
  - [Email](#email)
  - [Federated Identity/Authentication](#federated-identityauthentication)
  - [Feed Readers](#feed-readers)
  - [File Sharing and Synchronization](#file-sharing-and-synchronization)
  - [Gateways and terminal sharing](#gateways-and-terminal-sharing)
  - [Media Streaming](#media-streaming)
  - [Misc/Other](#miscother)
  - [Money, Budgeting and Management](#money-budgeting-and-management)
  - [Monitoring](#monitoring)
  - [Note-taking and Editors](#note-taking-and-editors)
  - [Password Managers](#password-managers)
  - [Personal Dashboards](#personal-dashboards)
  - [Photo and Video Galleries](#photo-and-video-galleries)
  - [Read it Later Lists](#read-it-later-lists)
  - [Software Development](#software-development)
  - [Task management/To-do lists](#task-managementto-do-lists)
  - [VPN](#vpn)
  - [Web servers](#web-servers)
  - [Wikis](#wikis)

## Analytics

- [Matomo](https://matomo.org/) - Web analytics

## Automation

- [Home Assistant](https://www.home-assistant.io/) - Home Automation
- [HomeBridge](https://homebridge.io/) - HomeKit support for the impatient
- [Kibitzr](https://kibitzr.github.io/) - IFTTT replacement

## Blogging Platforms

- [Ghost](https://ghost.org/) - Ghost is a platform for building and running a modern online publication

## Calendaring and Contacts Management

- [NextCloud](https://nextcloud.com/) - Private Cloud Storage, Calendar, Contacts, etc.

## Chat

- [The Lounge](https://thelounge.chat/) - Always-on IRC client (IRC bouncer)
- [Zulip](https://github.com/zulip/zulip) - Threaded chat software

## Document Management

- [Mayan EDMS](https://gitlab.com/mayan-edms/mayan-edms) - Free Open Source DMS (document management system).
- [Paperless](https://github.com/danielquinn/paperless) - Document management

## E-Books

- [Calibre](https://calibre-ebook.com) - Complete ebook library management.

## Email

- [Mailserver](https://github.com/hardware/mailserver/) - Fully featured mail server
- [Mailu](https://mailu.io/1.7/general.html) - is a simple yet full-featured mail server as a set of Docker images.

## Federated Identity/Authentication

- [Authelia](https://www.authelia.com) - Authelia is an open-source full-featured authentication server available on Github
- [PhpLDAPadmin](https://github.com/osixia/docker-phpLDAPadmin) - LDAP management interface

## Feed Readers

- [FreshRSS](https://freshrss.org) - A free, self-hostable aggregator
- [Miniflux](https://miniflux.app/) - Miniflux is a minimalist and opinionated feed reader.

## File Sharing and Synchronization

- [Jackett](https://github.com/Jackett/Jackett) - API Support for your favorite torrent trackers (helps Sonarr and Radarr)
- [Lidarr](https://lidarr.audio) - Sonarr but for Music.
- [Minio](https://minio.io/) - S3 hosting
- [Mylar](https://github.com/evilhero/mylar) - An automated Comic Book manager
- [Ombi](https://ombi.io) - Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves!
- [Radarr](https://radarr.video/) - Automated movie downloading
- [SickChill](https://sickchill.github.io/) - SickChill is an automatic Video Library Manager for TV Shows.
- [Sonarr](https://sonarr.tv/) - Automated TV downloading
- [Syncthing](https://syncthing.net/) - File syncing software
- [Transmission](https://transmissionbt.com/) - BitTorrent client

## Gateways and terminal sharing

- [Guacamole](https://guacamole.apache.org) - a clientless remote desktop gateway
- [WebVirtMg](https://github.com/retspen/webvirtmgr) is a complete Kernel Virtual Machine (KVM) hypervisor manager.

## Media Streaming

- [Airsonic](https://airsonic.github.io/) - Airsonic is a free, web-based media streamer, providing ubiquitous access to your music.
- [Beets](https://beets.io) - Beets is the media library management system for obsessive-compulsive music geeks.
- [Emby](https://emby.media/) - Personal Media Server
- [Jellyfin](https://github.com/jellyfin/jellyfin) - The Free Software Media System
- [MStream](https://www.mstream.io) - All your music, everywhere you go.
- [Plex](https://www.plex.tv/) - Personal Media Server

## Misc/Other

- [Darksky](http://darksky.net/) - Local weather reported via [darksky-influxdb](https://github.com/ErwinSteffens/darksky-influxdb)
- [Dasher](https://github.com/maddox/dasher) - Amazon Dash button support
- [Documentation](https://nickbusey.gitlab.io/HomelabOS/) - Offline, searchable documentation via [MkDocs](https://www.mkdocs.org/)
- [Mashio](https://gitlab.com/NickBusey/mashio) - Home brewery management software
- [Monica](https://www.monicahq.com/) - Contact / relationship manager
- [Pi-hole](https://pi-hole.net/) - Ad blocking
- [Poli](https://github.com/shzlw/poli) - An easy-to-use BI server built for SQL lovers. Power data analysis in SQL and gain faster business insights.
- [Portainer](https://www.portainer.io/) - Easy Docker management
- [Searx](https://github.com/asciimoo/searx/) - A privacy-respecting, hackable metasearch engine.
- [Ubooquity](https://vaemendis.net/ubooquity/) - Ubooquity is a free home server for your comics and ebooks library
- [Watchtower](https://containrrr.github.io/watchtower/) - A process for automating Docker container base image updates

## Money, Budgeting and Management

- [Firefly III](https://firefly-iii.org/) - Money management budgeting app

## Monitoring

- [Grafana](https://grafana.com/) - Pretty graphs
- [HealthChecks](HealthChecks.io) - A Cron Monitoring Tool written in Python & Django https://healthchecks.io
- [InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) - Time series data storage
- [NetData](http://my-netdata.io/) - Monitor your systems and applications, the right way!
- [Speedtest](https://github.com/atribe/Speedtest-for-InfluxDB-and-Grafana) - A tool to run periodic speedtests and save them in InfluxDB for graphing in Grafana
- [Tautulli](https://tautulli.com/) - Monitor your Plex Server
- [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) - Server statistics reporting

## Note-taking and Editors

- [BulletNotes](https://gitlab.com/NickBusey/BulletNotes.git) - Note taking application
- [Trilium](https://github.com/zadam/trilium) - Build your personal knowledge base with Trilium Notes

## Password Managers

- [Bitwarden](https://bitwarden.com/) - Password and secrets manager via [bitwarden-rs](https://github.com/dani-garcia/bitwarden_rs)

## Personal Dashboards

- [Homedash](https://lamarios.github.io/Homedash2/) - Dashboard
- [Organizr](https://github.com/causefx/Organizr) - Access all your HomelabOS services in one easy place.

## Photo and Video Galleries

- [Digikam](https://www.digikam.org) - Professional Photo Management with the Power of Open Source
- [OwnPhotos](https://github.com/hooram/ownphotos) Self hosted Google Photos clone.
- [Piwigo](https://piwigo.org/) - Manage your photo collection
- [Pixelfed](https://pixelfed.org/) - A free and ethical photo sharing platform, powered by ActivityPub federation.

## Read it Later Lists

- [Wallabag](https://wallabag.org/en) - Save and classify articles. Read them later. Freely.

## Software Development

- [Code-Server](https://github.com/codercom/code-server) - Run VS Code on a remote server.
- [Drone](https://drone.io) - Drone is a self-service continuous delivery platform
- [Gitea](https://gitea.io/en-US/) - Git hosting

## Task management/To-do lists

- [Wekan](https://wekan.github.io/) - Open source Kanban board with MIT license

## VPN

- [OpenVPN](https://openvpn.net/) - A Business VPN to Access Network Resources Securely

## Web servers

- [Apache](https://httpd.apache.org/) - Web server

## Wikis

- [BookStack](https://www.bookstackapp.com/) - Simple & Free Wiki Software

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
