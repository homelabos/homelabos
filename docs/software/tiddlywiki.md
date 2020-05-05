# Tiddlywiki

[Tiddlywiki](https://tiddlywiki.com) a unique non-linear notebook for capturing, organizing and sharing complex information

## Access

It is available at [https://{% if tiddlywiki.domain %}{{ tiddlywiki.domain }}{% else %}{{ tiddlywiki.subdomain + "." + domain }}{% endif %}/](https://{% if tiddlywiki.domain %}{{ tiddlywiki.domain }}{% else %}{{ tiddlywiki.subdomain + "." + domain }}{% endif %}/) or [http://{% if tiddlywiki.domain %}{{ tiddlywiki.domain }}{% else %}{{ tiddlywiki.subdomain + "." + domain }}{% endif %}/](http://{% if tiddlywiki.domain %}{{ tiddlywiki.domain }}{% else %}{{ tiddlywiki.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ tiddlywiki.subdomain + "." + tor_domain }}/](http://{{ tiddlywiki.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
tiddlywiki:
  https_only: True
  auth: True
```