# Vaultwarden

[Vaultwarden](https://github.com/dani-garcia/vaultwarden/) is an open source password manager 

HomelabOS utilizes an Open Source clone of the Bitwarden API server, [vaultwarden](https://github.com/dani-garcia/vaultwarden) 

This is primarily due to performance and complexity reasons. `vaultwarden` requires just one Docker container, whereas the official `Bitwarden` install requires something like six different containers.

The docker image comes from [vaultwarden/server](https://hub.docker.com/r/vaultwarden/server)

## Security Note

Password managers like Vaultwarden should only be used over HTTPS

Ensure you have valid certificates in place before beginning to use this service

## Access

It is available at [https://{% if vaultwarden.domain %}{{ vaultwarden.domain }}{% else %}{{ vaultwarden.subdomain + "." + domain }}{% endif %}/](https://{% if vaultwarden.domain %}{{ vaultwarden.domain }}{% else %}{{ vaultwarden.subdomain + "." + domain }}{% endif %}/) or [http://{% if vaultwarden.domain %}{{ vaultwarden.domain }}{% else %}{{ vaultwarden.subdomain + "." + domain }}{% endif %}/](http://{% if vaultwarden.domain %}{{ vaultwarden.domain }}{% else %}{{ vaultwarden.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ vaultwarden.subdomain + "." + tor_domain }}/](http://{{ vaultwarden.subdomain + "." + tor_domain }}/)
{% endif %}
