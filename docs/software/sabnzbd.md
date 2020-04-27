# Sabnzbd

[Sabnzbd](https://sabnzbd.org/) Free and easy binary newsreader

## Access

It is available at [https://sabnzbd.{{ domain }}/](https://sabnzbd.{{ domain }}/) or [http://sabnzbd.{{ domain }}/](http://sabnzbd.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://sabnzbd.{{ tor_domain }}/](http://sabnzbd.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

sabnzbd:
  https_only: True
  auth: True