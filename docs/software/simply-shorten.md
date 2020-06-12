# Simply-Shorten

[Simply-Shorten](https://github.com/draganczukp/simply-shorten) A simple selfhosted URL shortener with no name because naming is hard

## Access

It is available at [https://{% if simply_shorten.domain %}{{ simply_shorten.domain }}{% else %}{{ simply_shorten.subdomain + "." + domain }}{% endif %}/](https://{% if simply_shorten.domain %}{{ simply_shorten.domain }}{% else %}{{ simply_shorten.subdomain + "." + domain }}{% endif %}/) or [http://{% if simply_shorten.domain %}{{ simply_shorten.domain }}{% else %}{{ simply_shorten.subdomain + "." + domain }}{% endif %}/](http://{% if simply_shorten.domain %}{{ simply_shorten.domain }}{% else %}{{ simply_shorten.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ simply_shorten.subdomain + "." + tor_domain }}/](http://{{ simply_shorten.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
simply_shorten:
  https_only: True
  auth: True
```
