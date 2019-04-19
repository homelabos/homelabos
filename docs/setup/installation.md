# Installation

[Download the latest version from GitLab](https://gitlab.com/NickBusey/HomelabOS/tags).

Make sure you have Ansible 2.5+ installed on your computer.

Ensure you can access your server with a local IP through [passwordless SSH](https://www.linuxbabe.com/linux-server/setup-passwordless-ssh-login) and your user has [passwordless sudo](https://askubuntu.com/questions/192050/how-to-run-sudo-command-with-no-password).

From inside the HomelabOS folder execute the terminal command `make config` to configure your server settings.

Once that is done, you can run `make` to have HomelabOS install itself.

To change any setting, edit your `config.yml` file, then run `make update`.

To reset your settings, run `make config_reset`, then run `make config` again.

## Syncing Settings via Git

HomelabOS will automatically keep the `settings/` folder in sync with a git repo if it has one.
So you can create a private repo on your Gitea instance for example, then clone that repo over the
settings folder. Now any changes you make to `config.yml` will be commited and pushed to that git
repo whenever you run `make`, `make update` or `make config`.

## Debugging

## [WARNING] Ansible is in a world writable directory (../HomelabOS), ignoring it as an ansible.cfg source.

Run `chmod 775 HomelabOS/` against the HomelabOS folder.

### 404

If you're up and running, but getting a 404, load [http://YOURSERVERIP:8181/]. This is the Traefik dashboard.
Each service under the `Frontends` column has a section `Route Rule - Host:`. The hostname after `Host:` is the
hostname that Traefik is listening to for that particular service. You need to be able to `ping` that hostname
from your computer, and you should get back the IP address of your server. Once that is the case, accessing the
hostname in a browser should load the respective service.

### No Traefik Dashboard

If you can't even access the dashboard listed above at :8181, check the status of the HomelabOS service with
`systemctl status homelabos`. This should give you some insight into what the issue is. Also you should be able
to run `docker ps | grep traefik` and get an output like:

```
8f00f6b3cdb6        traefik                        "/traefik"               13 hours ago        Up 13 hours                     0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:8181->8080/tcp           homelabos_traefik_1
```

### SSL Not working

Traefik generates SSL certs via LetsEncrypt, and LetsEncrypt has rate limiting. So it may take several days before
all of your services get valid SSL certs generated for them. You can tail the logs of the traefik container to see
the status of it's generation.

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make` command completes, it creates a file on the server at `/var/homelabos/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.

## NAS Network Area Storage Configuration

It is a good idea to keep your files as a whole, media, documents, etc., on a Network Area Storage device or NAS.

For a typical HomelabOS setup you will want at least the following directories inside your NAS:

```
Backups
Music
Movies
TV
Downloads
Documents
```

All you have to do is enter your NAS network path, username and password into your `host_vars/myserver` file. You can find the template in `host_vars/all` in the `# NAS Config` section.

It should look something like this, depending on your setup:

```
nas_path: //192.168.1.1/Mynas
nas_user: guest
nas_pass:
nas_workgroup: WORKGROUP
```

This NAS resource will be mounted under `/mnt/nas` in the various containers that would benefit from access.

Assuming you have created the folders above, for [Emby](/software/emby) for example you could point it to `/mnt/nas/TV` and `/mnt/nas/Movies` while [Paperless](/software/paperless) would point at `/mnt/nas/Documents`.
