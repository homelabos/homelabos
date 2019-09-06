# 0.7
- Added HealthChecks - A Cron Monitoring Tool written in Python & Django https://healthchecks.io
- Added [Pixelfed](https://pixelfed.org/) - A free and ethical photo sharing platform, powered by ActivityPub federation.
- Added Apache 2 - Web server
- Added Digikam - Professional Photo Management with the Power of Open Source
- Added HomeBridge - HomeKit support for the impatient
- Added Mylar - An automated Comic Book manager
- Added Ombi - Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves!
- Added SickChill - SickChill is an automatic Video Library Manager for TV Shows.
- Added Tautulli - Monitor your Plex Server
- Added Trilium - Build your personal knowledge base with Trilium Notes
- Added Watchtower - A process for automating Docker container base image updates
- Added Wekan - Open source Kanban board with MIT license
- Added WireGuard - Replaced tinc with WireGuard for faster Bastion host access

## Release Notes

If you are currently using a bastion host via Tinc, when upgrading to 0.7,
set `bastion.reset_iptables` to True. This will blow away any and all iptables
rules so use this option with care.

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
