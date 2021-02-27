# qBittorrent

[qBittorrent](https://www.qbittorrent.org/) An open-source alternative to µTorrent

## Access

It is available at [https://{% if qbittorrent.domain %}{{ qbittorrent.domain }}{% else %}{{ qbittorrent.subdomain + "." + domain }}{% endif %}/](https://{% if qbittorrent.domain %}{{ qbittorrent.domain }}{% else %}{{ qbittorrent.subdomain + "." + domain }}{% endif %}/) or [http://{% if qbittorrent.domain %}{{ qbittorrent.domain }}{% else %}{{ qbittorrent.subdomain + "." + domain }}{% endif %}/](http://{% if qbittorrent.domain %}{{ qbittorrent.domain }}{% else %}{{ qbittorrent.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ qbittorrent.subdomain + "." + tor_domain }}/](http://{{ qbittorrent.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
qbittorrent:
  https_only: True
  auth: True
```
