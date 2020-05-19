# Lazylibrarian

[Lazylibrarian](https://lazylibrarian.gitlab.io/) LazyLibrarian is a program to follow authors and grab metadata for all your digital reading needs.

## Access

It is available at [https://{% if lazylibrarian.domain %}{{ lazylibrarian.domain }}{% else %}{{ lazylibrarian.subdomain + "." + domain }}{% endif %}/](https://{% if lazylibrarian.domain %}{{ lazylibrarian.domain }}{% else %}{{ lazylibrarian.subdomain + "." + domain }}{% endif %}/) or [http://{% if lazylibrarian.domain %}{{ lazylibrarian.domain }}{% else %}{{ lazylibrarian.subdomain + "." + domain }}{% endif %}/](http://{% if lazylibrarian.domain %}{{ lazylibrarian.domain }}{% else %}{{ lazylibrarian.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ lazylibrarian + "." + tor_domain }}/](http://{{ lazylibrarian + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
lazylibrarian:
  https_only: True
  auth: True
```