# PhotoPrism

[PhotoPrism](https://photoprism.org) Personal Photo Management powered by Go and Google TensorFlow. Free and open-source.

## Access

It is available at [https://photoprism.{{ domain }}/](https://photoprism.{{ domain }}/) or [http://photoprism.{{ domain }}/](http://photoprism.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://photoprism.{{ tor_domain }}/](http://photoprism.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

photoprism:
  https_only: True
  auth: True