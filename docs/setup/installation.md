# Installation

!!! Warning "Beta Software Warning"

    This software has not reached version 1.0 and should therefore be considered unstable. While any tagged version should work well on its own, a nice friendly upgrade path from one version to another is not guaranteed.

    If you like getting your hands dirty in early versions of software, this is for you. If you prefer to wait till things are stable and friendly, maybe hold off for a while.

    Also, if you trash your server or wreck your data, that's on you. Test your backups. Trust nothing.

* [Watch Video Tutorial - Cloud Based Server](https://youtu.be/p8cD349BGRI)
* [Watch Video Tutorial - Local Server](https://youtu.be/Zy6Xfl5b5z4)

## Requirements

### Server

- Ubuntu Server 18.04 or Debian 10.3
- [Passwordless SSH via SSH keys](https://linuxconfig.org/passwordless-ssh) working.

!!! Warning
    If you are running on an ARM infrastructure such as Raspberry PI, set `arm` to true. Run: `./set_setting.sh arm True`

## Optional Items

### Client Computer

* Docker installed and working.

!!! Note
    Two separate computers are not required, but are highly recommended. The idea is you have a server and then your personal computer, say a laptop or desktop. You deploy from your personal computer to the server. This way your settings are saved on your personal computer, and can be used to re-build the server and restore from backups if anything goes wrong.

!!! Warning
    If you do install HomelabOS directly on the server and deploy from there, make sure to back up your `settings/` folder from the server to somewhere safe, otherwise you could lose your settings.

### Domain Name

A domain configured with a `A` type DNS record of `*.yourdomain.com` pointed at your server's IP address. You can also use a subdomain as well, so `*.homelab.yourdomain.com` would work.

!!! Note
    This is optional because you can use Tor to access your services without registering a domain. For best support from 3rd party clients an actual domain is highly recommended. Also certain services do not work through TOR at the moment.

!!! Note
    It's easiest to have an actual domain to point at your services, but you can `fake` it by adding DNS overrides to your `/etc/hosts` file on *nix and MacOS if needed or for testing.

#### DNS Settings

You need to point your `{{ domain }}`, as well as `*.{{ domain }}` to the IP address your HomelabOS install is accessible at. If you are using a [bastion](/docs/setup/bastion) host, then you would point at that IP. If you are using your home IP address, you would point it at that IP. You need to set up a wildcard DNS entry because all the services are served off of subdomains such as `emby.{{ domain }}`

!!! Warning
    If you are not using a real domain, but using `/etc/hosts` entries to 'fake' it, wildcard entries do not work in `/etc/hosts`. You need to create an entry for each service enabled. You can use the `/var/homelabos/homelab_hosts` file.

#### Changing your domain

If you need to change your domain (or subdomain) simply run `./set_setting.sh domain new.domain.com` then run `make` again.

### Port Forwarding

Ports 80 and 443 punched through any firewalls and port forwarded at your server in question.

!!! Note
    This is optional because if you are using the [bastion](bastion.md) server or [TOR access](tor.md), you do not need to deal with port forwarding or firewalls.

### [Cloud Bastion Server](bastion.md)

Rather than pointing the domain at your home IP and having to manage DDNS, you can utilize a cloud server
to act as a bastion host via Tinc vpn and nginx.

### S3 Account

S3 is Amazon's Simple Storage Service which HomelabOS can optionally use to back up to. You can use Amazon's service, or one of many other S3 compatible providers. You can also back up to another HomelabOS instance if that other instance is running Minio, a self-hosted S3 service.

## Automatic Set-up (One-liner)

* On your server run: `bash <(curl -s https://gitlab.com/NickBusey/HomelabOS/-/raw/dev/install_homelabos.sh)`

* Make sure to back up your `{{ volumes_root }}/install` directory nightly.

## Manual Set-up

* Download the [latest version](https://gitlab.com/NickBusey/HomelabOS/-/releases) to your client computer and extract the folder.

!!! Note
    If you are using HomelabOS to provision a [bastion](bastion.md) server, run: `$ make terraform`

* From inside the HomelabOS folder, set up the initial config: `make config`

!!! Note
    You will be prompted for the basic information to get started. The passwords entered here will be stored on the client computer and are used by ansible to configure your server. After you enter the information, HomelabOS will configure your local docker images and build your initial `settings/` files.

* Once you have updated your settings simply deploy HomelabOS with `make`. You can run `make` as many times as
needed to get your settings correct.

You can check http://{{ homelab_ip }}:8181 in a browser to see the Traefik dashboard.

If it is empty, images may still be downloading. You can SSH into the server, and run
`systemctl status SERVICENAME` like `systemctl status organizr` if you want to see if Organizr
is running. It will show you status and/or errors of the service.

See a full list of commands in the [Getting Started Section](/docs/setup/gettingstarted)

### Syncing Settings via Git

HomelabOS will automatically keep the `settings/` folder in sync with a git repo if it has one.
So you can create a private repo on your Gitea instance for example, then clone that repo over the
settings folder. Now any changes you make to `settings/` files will be commited and pushed to that git
repo whenever you run `make`, `make update` or `make config`.

## Troubleshooting / FAQ

??? note "`make` command throws a docker related error"
    * Make sure HomelabOS successfully installed docker on the server. If its not installed, try installing it manually.
    ```
    [server]$ docker run hello-world
    ``` 
    * Make sure you are running the latest docker and docker compose on both your client and server. The Docker version installed via `apt` can be old. Recommended install directions are [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    * Check HomelabOS status on the server and make sure it is loaded and active.
    ```
    [server]$ systemctl status homelabos
    ``` 
    * Make sure the admin user specified during `make config` is created.
    ```
    [server]$ compgen -u
    ```
    * If the user isn't listed, run the following commands to make one and add it to the sudo and docker groups.
    ```
    [server]$ sudo adduser <username>
    [server]$ sudo usermod -aG sudo <username>
    [server]$ sudo usermod -aG docker <username>
    ```

??? note "I have pointed my domain at my IP but hitting the domain returns nothing"
    * If you ping your `{{ domain }}`, do you get the IP you expect?
        * If not you have [DNS issues](/docs/setup/installation/#dns-settings). Get those resolved before moving on.
    * If you ping `subdomain.{{ domain }}`, do you get the IP you expect?
        * If not you have [DNS issues](/docs/setup/installation/#dns-settings). You probably don't have a wildcard set up.
    * Does the IP you expect actually lead to port 80 on your server?
        * You may need to set up port forwarding on your router, unblock some ports on your modem, or contact your ISP to see if they are being blocked. If these aren't an option for you, try the [bastion host](/setup/bastion) set up.
    * Does the domain you're trying to hit match what is listed in the Traefik dashboard?
        * If you don't see your domain under the 'HTTP' section in Traefik, then you have something configured wrong.
    * Are your services running? Check `docker ps` and `systemctl status SERVICENAME`
        * E.g. `systemctl status organizr` on the server.
    * Are your services listed in the Traefik dashboard? Hit http://{{ homelab_ip }}:8181/

    If you can hit DOMAIN.com and get SERVER_IP where port 80 and 443 are forwarded and DOMAIN.com is listed in Traefik as the Organizr endpoint, and you STILL can't load the page, ask in [chat](https://homelabos.zulipchat.com/) or open an issue on [GitLab](https://gitlab.com/NickBusey/HomelabOS/-/issues).

??? note "I get a 404"
    If you're up and running, but getting a 404, load [http://YOURSERVERIP:8181/]. This is the Traefik dashboard.

    Each service under the `Http` page has a section. The hostname inside `Host()` in the rule column is the hostname that Traefik is listening to for that particular service. You need to be able to `ping` that hostname from your computer, and you should get back the IP address of your server. Once that is the case, accessing the hostname in a browser should load the respective service.

    Traefik serves based on domain names, not IP addresses. It has to know what service you want to return. You need to be able to hit {{ domain }} or servicename.{{ domain }} in order for Traefik to serve the correct service.

??? note "No Traefik Dashboard"
    If you can't even access the dashboard listed above at :8181, check the status of the HomelabOS service.
    ```
    [server]$ systemctl status homelabos
    ```
    This should give you some insight into what the issue is. Also you should be able to run 
    ```
    [server]$ docker ps | grep traefik
    ```
    and get an output like:
    ```
    8f00f6b3cdb6        traefik                        "/traefik"               13 hours ago        Up 13 hours                     0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:8181->8080/tcp           homelabos_traefik_1
    ```

??? note "Bad Gateway or Services Restarting"
    If Traefik returns a page that just says `Bad Gateway`, that usually means DNS and everything is correct, but the service itself is having problems. SSH into the server and run `systemctl status SERVICE_NAME` replacing SERVICE_NAME with the service you are interested in. This should show you any relevant Docker logs. If you want more detail from a specific container, you can tail the logs of thatcontainer. Find the containar name with `docker ps | grep SERVICENAME` then access the logs with `docker logs -f --tail 500 CONTAINERNAME`.

??? note "SSL Not working"
    Traefik generates SSL certs via LetsEncrypt, and LetsEncrypt has rate limiting. So it may take several days before all of your services get valid SSL certs generated for them. You can tail the logs of the traefik container to see the status of it's generation.

??? note "I can't find certain config values like Authelia"
    Check your `config/vault.yml` file. If it's encrypted just run `make decrypt`

??? note "I get `exec user process caused 'exec format error'`"
    You are trying to run AMD code on ARM infrastructure. Make sure you have set `arm` to True in your config file.

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make` command completes, it creates a file on the server at `{{ volumes_root }}/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.

## NAS Network Attached Storage Configuration

Different HomelabOS services operate on libraries of media (Airsonic, Plex, and Piwigo as examples). Since these libraries can be large, it makes sense to keep them on another machine with lots of storage.

NAS shares are mounted on the HomelabOS host under `{{ storage_dir }}`, which defaults to `/mnt/nas`. By default, NAS is disabled, and the services that can use it will instead use local folders under `{{ storage_dir }}`.

For example, [Emby](/software/emby) will map `{{ storage_dir }}/Video/TV` and `{{ storage_dir }}/Video/Movies` into its container, and [Paperless](/software/paperless) will mount `{{ storage_dir }}/Documents`. Check the `docker-compose` files for each service to see what directories are used.

HomelabOS takes an all-or-nothing approach to remote storage. If you configure a NAS, all services that can use it will. For a full HomelabOS setup, the following shares should be present on your NAS:

```
Backups
Books
Documents
Downloads
Music
Pictures
temp
Video
```

These shares will be individually mounted on the HomelabOS host.

To configure your NAS, edit the `# NAS Config` section of `settings/config.yml`.

1. Enable NAS by setting `nas_enable: True`
2. Set `nas_host` to the hostname, FQDN, or IP address of your NAS.
3. Choose your network share type (`nfs` or `smb`) and set `nas_share_type` to that value.
4. Set your `nas_share_path`, if applicable. SMB shares will probably not have a value for this, but NFS will.
5. If authenticating to access SMB shares, set your username and password in `nas_user` and `nas_path`.
6. Set your Windows domain in `nas_workgroup`, if applicable.

Re-run `make` to configure and enable your NAS.

Here's an example NFS configuration, specifically for [unRAID](https://unraid.net):

```
nas_enable: True
nas_host: unraid.mydomain.com
nas_mount_type: nfs
nas_share_path: /mnt/user
nas_user:
nas_pass:
nas_workgroup:
```

Here's an example SMB configuration, this time using its IP address, an authenticated user and share name:

```
nas_enable: True
nas_host: 192.168.1.12
nas_mount_type: smb
nas_share_path: homelab
nas_user: user
nas_pass: 12345
nas_workgroup: WORKGROUP
```
