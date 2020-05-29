# WebTrees

[WebTrees](https://www.webtrees.net) Online Genealogy

## Access

It is available at [https://webtrees.{{ domain }}/](https://webtrees.{{ domain }}/) or [http://webtrees.{{ domain }}/](http://webtrees.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://webtrees.{{ tor_domain }}/](http://webtrees.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
webtrees:
  https_only: True
  auth: True
```
