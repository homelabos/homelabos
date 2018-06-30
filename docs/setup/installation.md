# Installation

Clone the repository if you have git `git clone git@gitlab.com:NickBusey/HomelabOS.git` or [download it from GitLab](https://gitlab.com/NickBusey/HomelabOS/-/archive/master/HomelabOS-master.zip).

Make sure you have Ansible 2.5+ installed on your computer.

Ensure you can access your server with a local IP through [passwordless SSH](https://www.linuxbabe.com/linux-server/setup-passwordless-ssh-login) and your user has [passwordless sudo](https://askubuntu.com/questions/192050/how-to-run-sudo-command-with-no-password).

From inside the HomelabOS folder execute the terminal command `make setup` to configure your server settings.

Once that is done, you can run `make` to have HomelabOS install itself.

To configure additional services, look at the options available in `group_vars/all` and override them in `host_vars/myserver`.

You can always change settings by hand in `host_vars/myserver` and re-run `make` again to update the server with your new settings.

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
