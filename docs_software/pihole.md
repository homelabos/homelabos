# Pi-hole

[Pi-hole](http://pi-hole.net/) provides network-wide ad blocking via your own Linux hardware.

## Configuration

Login with the default password you set.

## Access

The dashboard is available at [https://{% if pihole.domain %}{{ pihole.domain }}{% else %}{{ pihole.subdomain + "." + domain }}{% endif %}/](https://{% if pihole.domain %}{{ pihole.domain }}{% else %}{{ pihole.subdomain + "." + domain }}{% endif %}/) or [http://{% if pihole.domain %}{{ pihole.domain }}{% else %}{{ pihole.subdomain + "." + domain }}{% endif %}/](http://{% if pihole.domain %}{{ pihole.domain }}{% else %}{{ pihole.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ pihole.subdomain + "." + tor_domain }}/](http://{{ pihole.subdomain + "." + tor_domain }}/)
{% endif %}
