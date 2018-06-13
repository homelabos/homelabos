# Installation

Clone the repository if you have git `git clone git@gitlab.com:NickBusey/HomelabOS.git` or [download it from GitLab](https://gitlab.com/NickBusey/HomelabOS/-/archive/master/HomelabOS-master.zip).

Make sure you have Ansible 2.5+ installed.

Copy `group_vars/homelabos` to `host_vars/myserver` and change the settings to match your setup.

Once you have set at a very minimum the required fields in that file, you can begin the installation.

Now from inside the HomelabOS folder execute the terminal command `make`.

You can always change settings and re-run `make` to update the server with these settings.

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make` command completes, it creates a file on the computer which ran make `/tmp/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.