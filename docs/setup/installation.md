# Installation

Clone the repository if you have git `git clone git@gitlab.com:NickBusey/HomelabOS.git` or [download it from GitLab](https://gitlab.com/NickBusey/HomelabOS/-/archive/master/HomelabOS-master.zip).

Make sure you have Ansible 2.5+ installed.

From inside the HomelabOS folder execute the terminal command `make setup` to configure your server settings.

Once that is done, you can run `make` to have HomelabOS install itself.

To configure additional services, look at the options available in `group_vars/homelabos` and override them in `host_vars/myserver`.

You can always change settings by hand in `host_vars/myserver` and re-run `make` again to update the server with your new settings.

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make` command completes, it creates a file on the computer which ran make `/tmp/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.
