# Guacamole

[Guacamole](https://guacamole.apache.org) is a clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH.

## Access

It is available at [https://Guacamole.{{ domain }}/](https://Guacamole.{{ domain }}/) or [http://Guacamole.{{ domain }}/](http://Guacamole.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://Guacamole.{{ tor_domain }}/](http://Guacamole.{{ tor_domain }}/)
{% endif %}
