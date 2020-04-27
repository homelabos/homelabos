# Minecraft

[Minecraft](https://hub.docker.com/r/itzg/minecraft-server) Minecraft server with select-able version 

## Access

It is available at [https://minecraft.{{ domain }}/](https://minecraft.{{ domain }}/) or [http://minecraft.{{ domain }}/](http://minecraft.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://minecraft.{{ tor_domain }}/](http://minecraft.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

minecraft:
  https_only: True
  auth: True