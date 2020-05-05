# PhotoPrism

[PhotoPrism](https://photoprism.org) Personal Photo Management powered by Go and Google TensorFlow. Free and open-source.

## Access

It is available at [https://{% if photoprism.domain %}{{ photoprism.domain }}{% else %}{{ photoprism.subdomain + "." + domain }}{% endif %}/](https://{% if photoprism.domain %}{{ photoprism.domain }}{% else %}{{ photoprism.subdomain + "." + domain }}{% endif %}/) or [http://{% if photoprism.domain %}{{ photoprism.domain }}{% else %}{{ photoprism.subdomain + "." + domain }}{% endif %}/](http://{% if photoprism.domain %}{{ photoprism.domain }}{% else %}{{ photoprism.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ photoprism.subdomain + "." + tor_domain }}/](http://{{ photoprism.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
photoprism:
  https_only: True
  auth: True
```