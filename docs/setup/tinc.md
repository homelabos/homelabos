# Tinc

HomelabOS can optionally use Tinc to configure a cloud based bastion server, which will route
to your HomelabOS instance without needing to forward ports on your home router.

This is desirable for three reasons.

1. Less configuration - No need to configure your routers or firewalls, no port forwarding to mess with.
2. Enhanced security - Your home IP address will not be exposed to the internet via DNS
3. Email - Most ISPs block the ports necessary for email, this circumvents that

## Setup

First you need a cloud server through a provider such as AWS or Digital Ocean.

Copy the `group_vars/tinc` file to `host_vars/tincserver`. Fill out all the required fields.

The ansible ssh user should have passwordless SSH and Sudo just like the HomelabOS server.

Now run `make update` as normal, and HomelabOS will take care of everything else.

Now point your domain name to your cloud server's IP address rather than your home IP address,
and everything should be happy!

## Access

You can SSH port 22 on your cloud server to access the cloud server itself. Or you can
SSH to port 2222 and you will be accessing the home server directly.

## sshuttle

You can also use [sshuttle](https://github.com/sshuttle/sshuttle) to access your server
via a VPN. Install sshuttle then run `sshuttle -r USER@CLOUD_SERVER_DOMAIN 0/0`.

You can now ssh directly to 10.0.0.1 and load http://10.0.0.1:8181 in a browser to
access the Traefik dashboard for example.
