# Dev

## Services Added
- Added phpBB - phpBB is an Internet forum package in the PHP scripting language.
- Added tubearchivist - Your self hosted YouTube media server
- Added ztncui - ZeroTier network controller user interface
- Added SEaT - A Simple, EVE Online API Tool and Corporation Manager

## Services Removed
- Removed darksky-influxdb - Darksky API is no longer.

## Improvements
- Improved script organization and deployment
- Improved documentation, now enabled by default
- Added service testing script
# 0.8.6

## Fixed
- Install script fix

# 0.8.5

## Changes
- Add configuration options to change Firefly's image and database

## Services Added
- Added Speedtest Tracker - An alternative tool to run periodic speedtests.
- Added Mealie - Simple recipes in Markdown format.
- Added Internet Monitoring - Internet Monitoring Docker Stack for tracking speed and ping over time with Prometheu + Grafana

# 0.8.4

- Documentation clean up

# 0.8.3

Bug fixes

# 0.8.2

Pull docker image rather than build by default

# 0.8.1

Bug fixes

# 0.8
## Services Added

- Added AdGuard Home - Network-wide software for blocking ads and tracking.
- Added Invoice Ninja - Free Open-Source Invoicing
- Added Jenkins - The leading open source automation server, Jenkins provides hundreds of plugins to support building, deploying and automating any project.
- Added QuakeJS - QuakeJS is a port of IOQuake3 to JavaScript with the help of Emscripten
- Added Rsshub - RSSHub is an open source, easy to use, and extensible RSS feed aggregator, it's capable of generating RSS feeds from pretty much everything.
- Added Samba - Export your HLOS storage_dirs as CIFS/SMB file shares
- Added Teedy - Document Management made simple for everyone
- Added Taisun - Single Server Docker Management for Humans
- Added Keycloak - Open Source Identity and Access Management
- Added The Spaghetti Detective - AI-based failure detection for 3D printer remote management and monitoring.
- Added matterbridge - Bridges between many different chat protocols.
- Added OctoPrint - The snappy web interface for your 3D printer.
- Added Simply-Shorten - A simple selfhosted URL shortener with no name because naming is hard
- Added Taisun - Single Server Docker Management for Humans
- Added Teedy - Document Management made simple for everyone
- Added Unifi Controller - The Unifi-controller Controller software is a powerful, enterprise wireless software engine ideal for high-density client deployments requiring low latency and high uptime performance.
- Added Xteve - An emulted TV Tuner for IPTV services.
- Added Invidious - An alternative front-end to YouTube

# 0.7.1 - 0.7.2

## Fixed

- Fixes for migrate_vault.sh

# 0.7

## Features

- Added Encrypted Secrets - All secrets stored in the settings repo are now automatically encrypted with Ansible Vault. Use `make decrypt` to see the values in the file. It re-encrypts when you run `make`.
- Added One-Line Deploy - `bash <(curl -s https://gitlab.com/NickBusey/HomelabOS/-/raw/dev/install_homelabos.sh)`
- Updated everything to use Traefik v2

## Services Added

- Added Apache 2 - Web server
- Added Authelia - Authelia is an open-source full-featured authentication server available on Github
- Added Barcode Buddy - Barcode system for Grocy
- Added CodiMD - The best platform to write and share markdown
- Added Cockpit - Cockpit admin interface package for configuring and troubleshooting a system
- Added Chowdown - Simple recipes in Markdown format
- Added Digikam - Professional Photo Management with the Power of Open Source
- Added DuckDNS - Free Dynamic DNS client
- Added ELK Stack - Elastic Search, Logstash and Kibana
- Added EtherCalc - EtherCalc is a web spreadsheet
- Added ERPNext - Open Source ERP for Everyone.
- Added Factorio - Factorio headless server in a Docker container
- Added folding_at_home - Folding@home software allows you to share your unused computer power with scientists researching diseases.
- Added Funkwhale - A social platform to enjoy and share music
- Added Grocy - ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home
- Added Gotify - A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)
- Added HealthChecks - A Cron Monitoring Tool written in Python & Django https://healthchecks.io
- Added Heimdall - Heimdall Application Dashboard is a dashboard for all your web applications.
- Added HomeBridge - HomeKit support for the impatient
- Added Hubzilla - a powerful platform for creating interconnected websites featuring a decentralized identity.
- Added Huginn - Create agents that monitor and act on your behalf. Your agents are standing by!
- Added Lazylibrarian - LazyLibrarian is a program to follow authors and grab metadata for all your digital reading needs.
- Added Mailu - is a simple yet full-featured mail server as a set of Docker images.
- Added MassiveDecks - Massive Decks is a comedy party game based on Cards against Humanity. Play with friends! It works great with a bunch of people in the same room on phones, or on voice chat online.
- Added Minecraft - Minecraft server with select-able version
- Added MinecraftBedrockServer - Minecraft Bedrock Server
- Added MStream - All your music, everywhere you go.
- Added Mylar - An automated Comic Book manager
- Added n8n - n8n is a free and open node based Workflow Automation Tool.
- Added NodeRED - Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.
- Added Ombi - Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves!
- Added PeerTube - ActivityPub Video Sharing
- Added PhotoPrism - Clearly structured Web interface for browsing, organizing and sharing your personal photo collection.
- Added Pixelfed - A free and ethical photo sharing platform, powered by ActivityPub federation.
- Added Pleroma - Pleroma is a federated social networking platform, compatible with GNU social and other OStatus implementations. It is free software licensed under the AGPLv3.
- Added Poli - An easy-to-use BI server built for SQL lovers. Power data analysis in SQL and gain faster business insights.
- Added PrivateBin - PrivateBin is a minimalist, open source online pastebin where the server has zero knowledge of pasted data.
- Added qBittorrent - An open-source alternative to µTorrent
- Added Sabnzbd - Free and easy binary newsreader
- Added Searx - A privacy-respecting, hackable metasearch engine.
- Added Shinobi - The Free Open Source CCTV platform written in Node.JS
- Added SickChill - SickChill is an automatic Video Library Manager for TV Shows.
- Added Snibox - Self-hosted snippet manager. Developed to collect and organize code snippets.
- Added Speedtest - A tool to run periodic speedtests and save them in InfluxDB for graphing in Grafana
- Added Statping - Web and App Status Monitoring for Any Type of Project
- Added Tautulli - Monitor your Plex Server
- Added Tiddlywiki - a unique non-linear notebook for capturing, organizing and sharing complex information
- Added Trilium - Build your personal knowledge base with Trilium Notes
- Added Turtl - A note taking API server with E2E encryption
- Added Ubooquity - Ubooquity is a free home server for your comics and ebooks library
- Added Watchtower - A process for automating Docker container base image updates
- Added WebDAV - a WebDAV service for secure http file transfer needs
- Added WebTrees - Online Genealogy
- Added Wekan - Open source Kanban board with MIT license
- Added WireGuard - Replaced tinc with WireGuard for faster Bastion host access
- Added Zammad - Zammad is a web-based, open source user support/ticketing solution.
- Added SUI - a startpage for your server and / or new tab page

## Services Removed

- Removed mailserver. It's no longer maintained.

## Release Notes

When upgrading to v0.7 you must run `make restart` for your services to show back up afterwards.

You will also be asked for your sudo password and preferred default_password again, due to the upgrade.

If you are currently using a bastion host via Tinc, when upgrading to 0.7, set `bastion.reset_iptables` to True. This will blow away any and all iptables rules so use this option with care.

The default storage location has been moved from `/mnt/homelabos/media` to `/mnt/nas`. Both the storage location and the HomelabOS installation directories are now configurable with `storage_dir` and `volumes_root`.

The `TV`, `Movies`, and `Comics` folders have moved to living inside `Video`. The new default location for TV for example would be `/mnt/nas/Video/TV`.

# 0.6.4

- Raspberry Pi specific fixes

# 0.6.3

- Docker fixes

# 0.6.2

- Initial configuration fixes

# 0.6.1

- Fixed various deployment issues

# 0.6

- Added Terraform Support - Optionally spin up cloud servers automatically
- Improved Tooling - Easily add new services not already included in HomelabOS via a Ruby script
- Improved Configuration - Added `make set` and `make get` commands to make working with the configuration easier.
- Improved documentation
- More options - More things are configurable than before
- Improved deployment - Cleaner Traefik settings
- Changed Requirements - No longer requires Ansible, only requires Docker to be installed.

# 0.5

- Greatly improved deployment - Each service is now fully independent from each other
- Improved SMTP Configuration - More services set up outgoing SMTP out of the box
- Improved Bastion Host Proxying - Better routing through iptables
- Improved documentation
- Improved security - Passwordless SUDO no longer required
- Added Automated Settings Sync via Git
- Added Airsonic - Airsonic is a free, web-based media streamer, providing ubiquitous access to your music.
- Added Beets - Beets is the media library management system for obsessive-compulsive music geeks.
- Added Bookstack - Simple & Free Wiki Software
- Added Code-Server - Run VS Code on a remote server
- Added Duplicati - Free backup software to store encrypted backups online. For Windows, macOS and Linux
- Added Drone - Drone is a self-service continuous delivery platform
- Added FreshRSS - A free, self-hostable aggregator
- Added Ghost - Ghost is a platform for building and running a modern online publication
- Added Guacamole - clientless remote desktop gateway
- Added Homedash - Home Server Dashboard Software
- Added Inventario - Home Inventory Management Software
- Added Jellyfin - The Free Software Media System
- Added Lidarr - Sonarr but for Music.
- Added Mailserver - Full self-hosted mail stack
- Added Mashio - Home Brewery Management Software
- Added Mayan EDMS - Free Open Source DMS (document management system).
- Added NetData - Monitor your systems and applications, the right way!
- Added openLDAP - Open Source LDAP Server
- Added Wallabag - Save and classify articles. Read them later. Freely.
- Added WebVirtMgr - a complete Kernel Virtual Machine (KVM) hypervisor manager.
- Added Zulip - Threaded Chat Software
- Many fixes and improvements across many services

# 0.4

- Vastly improved initial setup
- Automated Grafana Configuration
- Added Cloud Bastion Server via Tinc VPN option
- Added individual service toggling via host vars
- Added The Lounge - IRC Bouncer
- Added Radarr - DVR
- Added Sonarr - DVR
- Added Kibitzr - IFTTT replacement
- Added BulletNotes - Note taking application
- Added Plex - Personal Media Server
- Upgraded Organizr to v2 - Dashboard
- Removed Koel - Rarely worked
- Removed Convos - Rarely worked

# 0.3

- Added Semi-automated Apple Health Import
- Added Automated HTTPS via LetsEncrypt
- Added Tor Onion Services - Remote access through any firewall
- Added OpenVPN - Remote device Ad filtering via piHole
- Added Mastodon - Federated social micro blogging
- Added Matomo - Web analytics
- Added Bitwarden - Password manager
- Added piHole - Network wide ad blocking

# 0.2

- Added Dasher / Amazon Dash Button support

# 0.1

- Initial release
