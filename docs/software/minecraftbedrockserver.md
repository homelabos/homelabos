# MinecraftBedrockServer

[MinecraftBedrockServer](https://www.minecraft.net/en-us/download/server/bedrock/) Minecraft Bedrock Server

## Access

It is available at [https://{% if minecraftbedrockserver.domain %}{{ minecraftbedrockserver.domain }}{% else %}{{ minecraftbedrockserver.subdomain + "." + domain }}{% endif %}/](https://{% if minecraftbedrockserver.domain %}{{ minecraftbedrockserver.domain }}{% else %}{{ minecraftbedrockserver.subdomain + "." + domain }}{% endif %}/) or [http://{% if minecraftbedrockserver.domain %}{{ minecraftbedrockserver.domain }}{% else %}{{ minecraftbedrockserver.subdomain + "." + domain }}{% endif %}/](http://{% if minecraftbedrockserver.domain %}{{ minecraftbedrockserver.domain }}{% else %}{{ minecraftbedrockserver.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ minecraftbedrockserver.subdomain + "." + tor_domain }}/](http://{{ minecraftbedrockserver.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
minecraftbedrockserver:
  https_only: True
  auth: True
```