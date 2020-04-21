# Transmission

[Transmission](https://transmissionbt.com/) is available for all your torrenting needs.

HomelabOS uses [docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) to only connect via a VPN. It includes Tinyproxy on port 8888 to provide proxy services over the OpenVPN client connection. To disable the OpenVPN functionality replace the line `image: haugene/transmission-openvpn` with `image: linuxserver/transmission` in `roles/transmission/templates/docker-compose.transmission.yml` then run `make` again from the root directory to update HomelabOS with your new settings.

## Access

It is available at [https://torrent.{{ domain }}/](https://torrent.{{ domain }}/) or [http://torrent.{{ domain }}/](http://torrent.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://torrent.{{ tor_domain }}/](http://torrent.{{ tor_domain }}/)
{% endif %}
