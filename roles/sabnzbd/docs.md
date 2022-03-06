# Sabnzbd

[Sabnzbd](https://sabnzbd.org/) Free and easy binary newsreader

## Access

It is available at [https://{% if sabnzbd.domain %}{{ sabnzbd.domain }}{% else %}{{ sabnzbd.subdomain + "." + domain }}{% endif %}/](https://{% if sabnzbd.domain %}{{ sabnzbd.domain }}{% else %}{{ sabnzbd.subdomain + "." + domain }}{% endif %}/) or [http://{% if sabnzbd.domain %}{{ sabnzbd.domain }}{% else %}{{ sabnzbd.subdomain + "." + domain }}{% endif %}/](http://{% if sabnzbd.domain %}{{ sabnzbd.domain }}{% else %}{{ sabnzbd.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ sabnzbd.subdomain + "." + tor_domain }}/](http://{{ sabnzbd.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
sabnzbd:
  https_only: True
  auth: True
```
