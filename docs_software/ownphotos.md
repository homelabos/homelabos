# OwnPhotos

[OwnPhotos](https://github.com/hooram/ownphotos) Self hosted Google Photos clone.

## Access

It is available at [https://{% if ownphotos.domain %}{{ ownphotos.domain }}{% else %}{{ ownphotos.subdomain + "." + domain }}{% endif %}/](https://{% if ownphotos.domain %}{{ ownphotos.domain }}{% else %}{{ ownphotos.subdomain + "." + domain }}{% endif %}/) or [http://{% if ownphotos.domain %}{{ ownphotos.domain }}{% else %}{{ ownphotos.subdomain + "." + domain }}{% endif %}/](http://{% if ownphotos.domain %}{{ ownphotos.domain }}{% else %}{{ ownphotos.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ownphotos.subdomain + "." + tor_domain }}/](http://{{ ownphotos.subdomain + "." + tor_domain }}/)
{% endif %}
