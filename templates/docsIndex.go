package templates

var DocsIndex = `# HomelabOS

Welcome to HomelabOS! Your very own offline-first open-source data-center!

HomelabOS is a collection of various separate services. You can find more information about each in the menu on the left.

## [Installation](setup/installation)

## [Getting Started](setup/gettingstarted)

## [Understanding Storage](setup/storage)

## Getting Help

If you are having problems you can:

- [File an issue on GitLab](https://gitlab.com/NickBusey/HomelabOS/issues).
- [Ask a question on HomelabOS Reddit](https://www.reddit.com/r/HomelabOS/)
- [Ask a question HomelabOS Zulip Chat](https://homelabos.zulipchat.com/)

## Available Software

### Categories

- [Analytics](#analytics)
- [Automation](#automation)
- [Blogging Platforms](#blogging-platforms)
- [Calendaring and Contacts Management](#calendaring-and-contacts-management)
- [Chat](#chat)
- [Docker & VM Management](#docker-vm-management)
- [Document Management](#document-management)
- [E-books](#e-books)
- [Email](#email)
- [Federated Identity/Authentication](#federated-identityauthentication)
- [Feed Readers](#feed-readers)
- [File Sharing and Synchronization](#file-sharing-and-synchronization)
- [Games](#games)
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
- [Social Networking](#social-networking)
- [Software Development](#software-development)
- [Task management/To-do lists](#task-managementto-do-lists)
- [VPN](#vpn)
- [Web servers](#web-servers)
- [Wikis](#wikis)

{{ range $category := . }}### {{ $category.Name }}
{{ range $service := $category.Services}}
#### [{{ $service.Name }}](/software/{{ $service.Name }})
{{ $service.Description }}
{{ end }}
{{ end }}
`
