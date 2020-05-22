# PeerTube

[PeerTube](https://peertube.social) ActivityPub Video Sharing

## Access

Peertube generates it's own root password on first startup. Homelabos captures that and stores it in ./settings/passwords/peertube_root_password

It is available at [https://peertube.{{ domain }}/](https://peertube.{{ domain }}/) or [http://peertube.{{ domain }}/](http://peertube.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://peertube.{{ tor_domain }}/](http://peertube.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

peertube:
  https_only: True
  auth: True
