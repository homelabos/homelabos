# SUI

[SUI](https://gitlab.com/WillFantom/sui) a startpage for your server and / or new tab page

## Access

It is available at [https://{% if sui.domain %}{{ sui.domain }}{% else %}{{ sui.subdomain + "." + domain }}{% endif %}/](https://{% if sui.domain %}{{ sui.domain }}{% else %}{{ sui.subdomain + "." + domain }}{% endif %}/) or [http://{% if sui.domain %}{{ sui.domain }}{% else %}{{ sui.subdomain + "." + domain }}{% endif %}/](http://{% if sui.domain %}{{ sui.domain }}{% else %}{{ sui.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ sui.subdomain + "." + tor_domain }}/](http://{{ sui.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
sui:
  https_only: True
  auth: True
```
