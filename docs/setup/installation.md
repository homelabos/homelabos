# Installation

* [Watch Video Tutorial - Cloud Based Server](https://youtu.be/p8cD349BGRI)
* [Watch Video Tutorial - Local Server](https://youtu.be/Zy6Xfl5b5z4)

## Requirements

### Client:
    *  Docker
    
If you don't want to install docker to your client (or if you're on windows), you can do everything on your server. Just make sure to setup Docker on your server first.

Verify docker is installed correctly on your client
```
[client]$ docker run hello-world
``` 


### Server:
    * Running Ubuntu 18.04
    * passwordless SSH via SSH keys
    
Ensure you can access your server with a IP through
[passwordless SSH](https://www.linuxbabe.com/linux-server/setup-passwordless-ssh-login)
and your user has sudo access.

## Set-up

1) Download the latest version from the link above to your client computer and extract the folder.

   IF you are going to be using HomelabOS to provision a cloud server, walk through the process. Otherwise you can skip this.
   
   ```
   [client]$ make terraform 
   ```


2) From inside the HomelabOS folder, set up the initial config

    ```
    [client]$ cd HomelabOS
    [client]$ make build
    [client]$ make config
    ``` 
    
   You will be prompted for the basic information to get started. The passwords entered here
   will be stored on the client computer and are used by ansible to configure your server. After you enter the information, 
   HomelabOS will configure your local docker images and build your initial `settings/config.yml`
   file.

3) To change any setting, you can either edit your `settings/config.yml` file, 
or use the `make set` command, e.g., `make set enable_bitwarden true`.

4) Once you have updated the `settings/config.yml` file through either method,
simply deploy HomelabOS. You can run `make` as many times as
needed to get your settings correct.

    ```
    [client]$ make
    ```

To reset your settings, run `make config_reset`, then run `make config` again.

See a full list of commands in the Getting Started Section

### Deploying to Cloud Services with Terraform

You can use our 
[Terraform scripts](https://gitlab.com/NickBusey/HomelabOS/blob/dev/docs/setup/terraform.md)
to spin up cloud servers to deploy against rather than needing
physical servers configured.

### Syncing Settings via Git

HomelabOS will automatically keep the `settings/` folder in sync with a git repo if it has one.
So you can create a private repo on your Gitea instance for example, then clone that repo over the
settings folder. Now any changes you make to `config.yml` will be commited and pushed to that git
repo whenever you run `make`, `make update` or `make config`.

## Troubleshooting

### `make config` throws an error

Build initial docker images on the client.

```
[client]$ make logo
```

### `make` command throws a docker related error

1) Make sure homelabOS successfully installed docker on the server. If its not installed, try installing it manually.

    ```
    [server]$ docker run hello-world
    ``` 

2) Make sure you are running the latest docker and docker compose on both your client and server. The Docker version installed via `apt` can be old. Recommended install directions are [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

3) Check HomelabOS status on the server and make sure it is loaded and active.

    ```
    [server]$ systemctl status homelabos
    ``` 

4) Make sure the admin user specified during `make config` is created.

    ```
    [server]$ compgen -u
    ```

   If the user isn't listed, run the following commands to make one and add it to the sudo and docker groups.
   
    ```
    [server]$ sudo adduser <username>
    [server]$ sudo usermod -aG sudo <username>
    [server]$ sudo usermod -aG docker <username>
    ```

### [WARNING] Ansible is in a world writable directory (../HomelabOS), ignoring it as an ansible.cfg source.

Run chmod 775 against the HomelabOS folder.
```
[client]$ chmod 775 HomelabOS/
```

### 404

If you're up and running, but getting a 404, load [http://YOURSERVERIP:8181/]. This is the Traefik dashboard.
Each service under the `Frontends` column has a section `Route Rule - Host:`. The hostname after `Host:` is the
hostname that Traefik is listening to for that particular service. You need to be able to `ping` that hostname
from your computer, and you should get back the IP address of your server. Once that is the case, accessing the
hostname in a browser should load the respective service.

### No Traefik Dashboard

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

### Bad Gateway

If Traefik returns a page that just says `Bad Gateway`, that usually
means DNS and everything is correct, but the service itself is having
problems. SSH into the server and run `systemctl status SERVICE_NAME`
replacing SERVICE_NAME with the service you are interested in.
This should show you any relevant Docker logs. If you want more
detail from a specific container, you can tail the logs of that
container. Find the containar name with `docker ps | grep SERVICENAME`
then access the logs with `docker logs -f --tail 500 CONTAINERNAME`.

### SSL Not working

Traefik generates SSL certs via LetsEncrypt, and LetsEncrypt has rate limiting. So it may take several days before
all of your services get valid SSL certs generated for them. You can tail the logs of the traefik container to see
the status of it's generation.

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make` command completes, it creates a file on the server at `/var/homelabos/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.

## NAS Network Attached Storage Configuration

Different HomelabOS services operate on libraries of media (for example: Airsonic, Plex, and Piwigo). Since these libraries can be large, it makes sense to keep them on another machine with lots of storage.

NAS shares are mounted on the HomelabOS host under `{{ storage_dir }}`, which defaults to `/mnt/homelabos/media`. By default, NAS is disabled, and the services that can use it will instead use local folders under `{{ storage_dir }}`.

For example, [Emby](/software/emby) will map `{{ storage_dir }}/TV` and `{{ storage_dir }}/Movies` into its container, and [Paperless](/software/paperless) will mount `{{ storage_dir }}/Documents`.

HomelabOS takes an all-or-nothing approach to remote storage. If you configure a NAS, all services that can use it will. For a full HomelabOS setup, the following shares should be present on your NAS:

```
Backups
Books
Documents
Downloads
Music
Movies
Pictures
temp
TV
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

Here's an SMB configuration for the same server, this time using its IP address and an authenticated user:

```
nas_enable: True
nas_host: 192.168.1.12
nas_mount_type: smb
nas_share_path:
nas_user: user
nas_pass: 12345
nas_workgroup: WORKGROUP
```
