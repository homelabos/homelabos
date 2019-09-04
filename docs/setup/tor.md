# Tor

If you don't have a domain, or your DNS fails you, or suddenly some ports aren't mapped correctly somewhere in your network, and you can't access your services remotely, fear not! Tor is here to save the day.

## Install Tor

Download Tor from the [Tor Project](https://www.torproject.org/) website.

## Web Access

Each page of the Software documentation section has a Tor URL beneath the normal URL.

## SSH Access

Make sure you have a working `torify` installation on your machine (not the server). Run `torify curl ifconfig.me` to verify you can connect to Tor with `torify`.

Now append the following lines to your `~/.ssh/config` file:

```
Host *.onion
   ProxyCommand /usr/bin/nc -xlocalhost:9150 -X5 %h %p
```
{% if enable_tor %}
Once that is done, you can ssh to your server with `torify ssh {{ ansible_user }}@{{ tor_ssh_domain }}`
{% endif %}
