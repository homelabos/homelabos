# Paperless-ngx

[Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) is a document management system that transforms your physical documents into a searchable online archive, so you can keep, well, less paper.

## Changing subdomain

After the initial installation of this service, it is recommended to change the subdomain to remove the underscore, e.g. from
```yaml
paperless_ngx:
  ...
  subdomain: paperless_ngx
  ...
```
to
```yaml
paperless_ngx:
  ...
  subdomain: paperless-ngx
  ...
```

## Access

It is available at [https://{% if paperless_ngx.domain %}{{ paperless_ngx.domain }}{% else %}{{ paperless_ngx.subdomain + "." + domain }}{% endif %}/](https://{% if paperless_ngx.domain %}{{ paperless_ngx.domain }}{% else %}{{ paperless_ngx.subdomain + "." + domain }}{% endif %}/) or [http://{% if paperless_ngx.domain %}{{ paperless_ngx.domain }}{% else %}{{ paperless_ngx.subdomain + "." + domain }}{% endif %}/](http://{% if paperless_ngx.domain %}{{ paperless_ngx.domain }}{% else %}{{ paperless_ngx.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ paperless_ngx.subdomain + "." + tor_domain }}/](http://{{ paperless_ngx.subdomain + "." + tor_domain }}/)
{% endif %}

## Migrations

Migration from the older versions of Paperless can be found here: https://paperless-ngx.readthedocs.io/en/latest/setup.html#migrating-to-paperless-ngx
