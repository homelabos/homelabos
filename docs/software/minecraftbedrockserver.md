# MinecraftBedrockServer

[MinecraftBedrockServer](https://www.minecraft.net/en-us/download/server/bedrock/) Minecraft Bedrock Server

## Access

It is available at [https://minecraftbedrockserver.{{ domain }}/](https://minecraftbedrockserver.{{ domain }}/) or [http://minecraftbedrockserver.{{ domain }}/](http://minecraftbedrockserver.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://minecraftbedrockserver.{{ tor_domain }}/](http://minecraftbedrockserver.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

minecraftbedrockserver:
  https_only: True
  auth: True