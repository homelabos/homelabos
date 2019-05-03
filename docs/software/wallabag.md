# Wallabag

[Wallabag](https://wallabag.org/en/) Save and classify articles. Read them later. Freely.

## Access

> Note. Until Homelabos has outbound mail capabilities, you'll need to rely on the default superadmin user
> User: wallabag
> Pass: wallabag

> _You should change that password._

It is available at [https://wallabag.{{ domain }}/](https://wallabag.{{ domain }}/) or [http://wallabag.{{ domain }}/](http://wallabag.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://wallabag.{{ tor_domain }}/](http://wallabag.{{ tor_domain }}/)
{% endif %}
