# RSSHub

[RSSHub](https://docs.rsshub.app/en/) RSSHub is an open source, easy to use, and extensible RSS feed aggregator, it's capable of generating RSS feeds from pretty much everything.

Additional config can be set via environment variables within the docker-compose file. Full configuragtion details can be [found here](https://docs.rsshub.app/en/install/#configuration).

## Access

It is available at [https://{% if rsshub.domain %}{{ rsshub.domain }}{% else %}{{ rsshub.subdomain + "." + domain }}{% endif %}/](https://{% if rsshub.domain %}{{ rsshub.domain }}{% else %}{{ rsshub.subdomain + "." + domain }}{% endif %}/) or [http://{% if rsshub.domain %}{{ rsshub.domain }}{% else %}{{ rsshub.subdomain + "." + domain }}{% endif %}/](http://{% if rsshub.domain %}{{ rsshub.domain }}{% else %}{{ rsshub.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ rsshub + "." + tor_domain }}/](http://{{ rsshub + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
rsshub:
  https_only: True
  auth: True
```
