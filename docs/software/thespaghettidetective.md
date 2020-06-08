# The Spaghetti Detective

[The Spaghetti Detective](https://thespaghettidetective.com) AI-based failure detection for 3D printer remote management and monitoring.

## Access

It is available at [https://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/](https://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/) or [http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/](http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ thespaghettidetective.subdomain + "." + tor_domain }}/](http://{{ thespaghettidetective.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
thespaghettidetective:
  https_only: True
  auth: True
```
