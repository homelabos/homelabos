# Minecraft

[Minecraft](https://hub.docker.com/r/itzg/minecraft-server) Minecraft server with select-able version 

## Access

It is available at minecraft.{{ domain }}:25565

{% if enable_tor %}
It is also available via Tor at minecraft.{{ tor_domain }}:25565
{% endif %}

## Settings
This options are exposed as settings in HomelabOS.

  - ONLINE_MODE: If this is True, users will check connecting players against Minecraft's account database. Disable to run a 'offline server'. 
  *Warning*: If this is set to False the server will be completly open to anyone able to connect. 

  - TYPE: Type of server to run, default y VANILLA. Check all options in repository README.

  - VERSION: Game server version, Default: LATEST, Exmaples: "1.7.9", "1.15.2"

*Notes:* This options are used at container creation, after the server is running, you will need to edit server.properties to change them.
