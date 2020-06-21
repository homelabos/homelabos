# QuakeJS

[QuakeJS](https://hub.docker.com/r/arkanus/quakejs/) QuakeJS is a port of IOQuake3 to JavaScript with the help of Emscripten

## Access

> Note, QuakeJS is only available via http. It will not work over https://

It is available at [http://{% if quakejs.domain %}{{ quakejs.domain }}{% else %}{{ quakejs.subdomain + "." + domain }}{% endif %}/](http://{% if quakejs.domain %}{{ quakejs.domain }}{% else %}{{ quakejs.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ quakejs.subdomain + "." + tor_domain }}/](http://{{ quakejs.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
quakejs:
  https_only: True
  auth: True
```
