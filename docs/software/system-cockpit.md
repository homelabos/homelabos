# cockpit

[cockpit](https://cockpit-project.org) Cockpit admin interface package for configuring and troubleshooting a system

## Access

It is available at [https://{% if cockpit.domain %}{{ cockpit.domain }}{% else %}{{ cockpit.subdomain + "." + domain }}{% endif %}/](https://{% if cockpit.domain %}{{ cockpit.domain }}{% else %}{{ cockpit.subdomain + "." + domain }}{% endif %}/) or [http://{% if cockpit.domain %}{{ cockpit.domain }}{% else %}{{ cockpit.subdomain + "." + domain }}{% endif %}/](http://{% if cockpit.domain %}{{ cockpit.domain }}{% else %}{{ cockpit.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ cockpit.subdomain + "." + tor_domain }}/](http://{{ cockpit.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
cockpit:
  https_only: True
  auth: True
```
