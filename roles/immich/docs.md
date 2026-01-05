# Immich

[Immich](https://immich.app) is a high performance self-hosted photo and video backup solution.

## Access

It is available at [https://{% if immich.domain %}{{ immich.domain }}{% else %}{{ immich.subdomain + "." + domain }}{% endif %}/](https://{% if immich.domain %}{{ immich.domain }}{% else %}{{ immich.subdomain + "." + domain }}{% endif %}/) or [http://{% if immich.domain %}{{ immich.domain }}{% else %}{{ immich.subdomain + "." + domain }}{% endif %}/](http://{% if immich.domain %}{{ immich.domain }}{% else %}{{ immich.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ immich.subdomain + "." + tor_domain }}/](http://{{ immich.subdomain + "." + tor_domain }}/)
{% endif %}

## Storage

- Library data: `{{ storage_dir }}/Pictures/immich`
- Database: `{{ volumes_root }}/immich/postgres`
- ML cache: `{{ volumes_root }}/immich/model-cache`

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
immich:
  https_only: True
  auth: True
```
