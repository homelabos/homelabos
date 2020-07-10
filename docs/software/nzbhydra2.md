# NZBHydra2

[NZBHydra2](https://github.com/theotherp/nzbhydra2/) NZBHydra 2 is a meta search for newznab indexers and torznab trackers.

## Access

It is available at [https://{% if nzbhydra2.domain %}{{ nzbhydra2.domain }}{% else %}{{ nzbhydra2.subdomain + "." + domain }}{% endif %}/](https://{% if nzbhydra2.domain %}{{ nzbhydra2.domain }}{% else %}{{ nzbhydra2.subdomain + "." + domain }}{% endif %}/) or [http://{% if nzbhydra2.domain %}{{ nzbhydra2.domain }}{% else %}{{ nzbhydra2.subdomain + "." + domain }}{% endif %}/](http://{% if nzbhydra2.domain %}{{ nzbhydra2.domain }}{% else %}{{ nzbhydra2.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nzbhydra2.subdomain + "." + tor_domain }}/](http://{{ nzbhydra2.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
nzbhydra2:
  https_only: True
  auth: True
```
