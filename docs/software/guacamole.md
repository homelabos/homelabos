# Guacamole

[Guacamole](https://guacamole.apache.org) is a clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH.

## Access

It is available at [https://{% if guacamole.domain %}{{ guacamole.domain }}{% else %}{{ guacamole.subdomain + "." + domain }}{% endif %}/guacamole](https://{% if guacamole.domain %}{{ guacamole.domain }}{% else %}{{ guacamole.subdomain + "." + domain }}{% endif %}/) or [http://{% if guacamole.domain %}{{ guacamole.domain }}{% else %}{{ guacamole.subdomain + "." + domain }}{% endif %}/](http://{% if guacamole.domain %}{{ guacamole.domain }}{% else %}{{ guacamole.subdomain + "." + domain }}{% endif %}/guacamole)

{% if enable_tor %}
It is also available via Tor at [http://{{ guacamole.subdomain + "." + tor_domain }}/guacamole](http://{{ guacamole.subdomain + "." + tor_domain }}/guacamole)
{% endif %}

## Default user and password
Use "guacadmin" for both user and password when logging in initially.
