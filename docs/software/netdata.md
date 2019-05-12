# Netdata

[Netdata](https://my-netdata.io/) Real-time performance monitoring, done right!

## Access

> Note. Netdata is protected by basic auth via the Traefik proxy. The user/pass is set at deployment time and is derived from the default_user and default_password set in the config.yml

It is available at [https://netdata.{{ domain }}/](https://netdata.{{ domain }}/) or [http://netdata.{{ domain }}/](http://netdata.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://netdata.{{ tor_domain }}/](http://netdata.{{ tor_domain }}/)
{% endif %}
