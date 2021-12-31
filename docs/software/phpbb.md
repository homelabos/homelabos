# phpBB

[phpBB](https://www.phpbb.com/) is an Internet forum package in the PHP scripting language.

## Access

It is available at [https://{% if phpbb.domain %}{{ phpbb.domain }}{% else %}{{ phpbb.subdomain + "." + domain }}{% endif %}/](https://{% if phpbb.domain %}{{ phpbb.domain }}{% else %}{{ phpbb.subdomain + "." + domain }}{% endif %}/) or [http://{% if phpbb.domain %}{{ phpbb.domain }}{% else %}{{ phpbb.subdomain + "." + domain }}{% endif %}/](http://{% if phpbb.domain %}{{ phpbb.domain }}{% else %}{{ phpbb.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ phpbb.subdomain + "." + tor_domain }}/](http://{{ phpbb.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
phpbb:
  https_only: True
  auth: True
```
