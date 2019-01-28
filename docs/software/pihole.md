# Pi-hole

[Pi-hole](http://pi-hole.net/) provides network-wide ad blocking via your own Linux hardware.

## Configuration

Login with the default password you set.

## Access

The dashboard is available at [https://pihole.{{ domain }}/](https://pihole.{{ domain }}/) or [http://pihole.{{ domain }}/](http://pihole.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://pihole.{{ tor_domain }}/](http://pihole.{{ tor_domain }}/)
{% endif %}
