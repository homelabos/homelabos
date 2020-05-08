# qBittorrent

[qBittorrent](https://www.qbittorrent.org/) An open-source alternative to µTorrent

## Access

It is available at [https://qbittorrent.{{ domain }}/](https://qbittorrent.{{ domain }}/) or [http://qbittorrent.{{ domain }}/](http://qbittorrent.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://qbittorrent.{{ tor_domain }}/](http://qbittorrent.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

qbittorrent:
  https_only: True
  auth: True