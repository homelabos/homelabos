# System-Cockpit

[System-Cockpit](https://cockpit-project.org) Cockpit admin interface package for configuring and troubleshooting a system

## Access

It is available at [https://{% if system-cockpit.domain %}{{ system-cockpit.domain }}{% else %}{{ system-cockpit.subdomain + "." + domain }}{% endif %}/](https://{% if system-cockpit.domain %}{{ system-cockpit.domain }}{% else %}{{ system-cockpit.subdomain + "." + domain }}{% endif %}/) or [http://{% if system-cockpit.domain %}{{ system-cockpit.domain }}{% else %}{{ system-cockpit.subdomain + "." + domain }}{% endif %}/](http://{% if system-cockpit.domain %}{{ system-cockpit.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ system-cockpit + "." + tor_domain }}/](http://{{ system-cockpit + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
system-cockpit:
  https_only: True
  auth: True
```