# Simply-Shorten

[Simply-Shorten](https://github.com/draganczukp/simplyshorten) A simple selfhosted URL shortener with no name because naming is hard

## Access

It is available at [https://{% if simplyshorten.domain %}{{ simplyshorten.domain }}{% else %}{{ simplyshorten.subdomain + "." + domain }}{% endif %}/](https://{% if simplyshorten.domain %}{{ simplyshorten.domain }}{% else %}{{ simplyshorten.subdomain + "." + domain }}{% endif %}/) or [http://{% if simplyshorten.domain %}{{ simplyshorten.domain }}{% else %}{{ simplyshorten.subdomain + "." + domain }}{% endif %}/](http://{% if simplyshorten.domain %}{{ simplyshorten.domain }}{% else %}{{ simplyshorten.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ simplyshorten.subdomain + "." + tor_domain }}/](http://{{ simplyshorten.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
simplyshorten:
  https_only: True
  auth: True
```
