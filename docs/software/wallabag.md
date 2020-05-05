# Wallabag

[Wallabag](https://wallabag.org/en/) Save and classify articles. Read them later. Freely.

## Access

> Note. Until Homelabos has outbound mail capabilities, you'll need to rely on the default superadmin user
> User: wallabag
> Pass: wallabag

> _You should change that password._

It is available at [https://{% if wallabag.domain %}{{ wallabag.domain }}{% else %}{{ wallabag.subdomain + "." + domain }}{% endif %}/](https://{% if wallabag.domain %}{{ wallabag.domain }}{% else %}{{ wallabag.subdomain + "." + domain }}{% endif %}/) or [http://{% if wallabag.domain %}{{ wallabag.domain }}{% else %}{{ wallabag.subdomain + "." + domain }}{% endif %}/](http://{% if wallabag.domain %}{{ wallabag.domain }}{% else %}{{ wallabag.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ wallabag.subdomain + "." + tor_domain }}/](http://{{ wallabag.subdomain + "." + tor_domain }}/)
{% endif %}
