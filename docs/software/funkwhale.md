# Funkwhale

[Funkwhale](https://Funkwhale.audio/en_US/) A social platform to enjoy and share music

## Access

It is available at [https://funkwhale.{{ domain }}/](https://funkwhale.{{ domain }}/) or [http://funkwhale.{{ domain }}/](http://funkwhale.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://funkwhale.{{ tor_domain }}/](http://funkwhale.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

funkwhale:
  https_only: True
  auth: True