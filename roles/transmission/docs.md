# Transmission

[Transmission](https://transmissionbt.com/) is available for all your torrenting needs.

HomelabOS uses [docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) to only connect via a VPN. It includes Tinyproxy on port 8888 to provide proxy services over the OpenVPN client connection. To disable the OpenVPN functionality replace the line `image: haugene/transmission-openvpn` with `image: linuxserver/transmission` in `roles/transmission/templates/docker-compose.transmission.yml.j2` then run `make` again from the root directory to update HomelabOS with your new settings.

## Access

It is available at [https://{% if transmission.domain %}{{ transmission.domain }}{% else %}{{ transmission.subdomain + "." + domain }}{% endif %}/](https://{% if transmission.domain %}{{ transmission.domain }}{% else %}{{ transmission.subdomain + "." + domain }}{% endif %}/) or [http://{% if transmission.domain %}{{ transmission.domain }}{% else %}{{ transmission.subdomain + "." + domain }}{% endif %}/](http://{% if transmission.domain %}{{ transmission.domain }}{% else %}{{ transmission.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ transmission.subdomain + "." + tor_domain }}/](http://{{ transmission.subdomain + "." + tor_domain }}/)
{% endif %}
