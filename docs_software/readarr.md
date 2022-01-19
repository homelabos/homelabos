# readarr

[readarr](https://readarr.com/) Sonarr but for Books.

## Access

It is available at [https://{% if readarr.domain %}{{ readarr.domain }}{% else %}{{ readarr.subdomain + "." + domain }}{% endif %}/](https://{% if readarr.domain %}{{ readarr.domain }}{% else %}{{ readarr.subdomain + "." + domain }}{% endif %}/) or [http://{% if readarr.domain %}{{ readarr.domain }}{% else %}{{ readarr.subdomain + "." + domain }}{% endif %}/](http://{% if readarr.domain %}{{ readarr.domain }}{% else %}{{ readarr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ readarr.subdomain + "." + tor_domain }}/](http://{{ readarr.subdomain + "." + tor_domain }}/)
{% endif %}