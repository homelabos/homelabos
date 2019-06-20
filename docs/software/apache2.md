# Apache 2

[Apache 2](https://httpd.apache.org/) is a free web server.

It is included with HomelabOS to serve directory listings or static sites.

After enabling apache2 and running `make`, just place the files you want to
server in `/var/homelabos/apache2/root/` on your server.

You can set the `apache2_subdomain` config setting to change the subdomain
from `apache2` to something else.

## Access

It is available at [https://{{ apache2_subdomain }}.{{ domain }}/](https://{{ apache2_subdomain }}.{{ domain }}/) or [http://{{ apache2_subdomain }}.{{ domain }}/](http://{{ apache2_subdomain }}.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ apache2_subdomain }}.{{ tor_domain }}/](http://{{ apache2_subdomain }}.{{ tor_domain }}/)
{% endif %}
