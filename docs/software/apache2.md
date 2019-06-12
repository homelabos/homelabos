# Apache 2

[Apache 2](https://httpd.apache.org/) is a free web server.

It is included with HomelabOS to serve directory listings or static sites.

After enabling apache2 and running `make`, just place the files you want to
server in `/var/homelabos/apache2/root/` on your server.

## Access

It is available at [https://apache2.{{ domain }}/](https://apache2.{{ domain }}/) or [http://apache2.{{ domain }}/](http://apache2.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://apache2.{{ tor_domain }}/](http://apache2.{{ tor_domain }}/)
{% endif %}
