# Ubooquity

[Ubooquity](https://vaemendis.net/ubooquity/) Ubooquity is a free home server for your comics and ebooks library

## Access

It is available at [https://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/ubooquity](https://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/ubooquity)

{% if enable_tor %}
It is also available via Tor at [http://{{ ubooquity.subdomain + "." + tor_domain }}/ubooquity](http://{{ ubooquity.subdomain + "." + tor_domain }}/ubooquity)
{% endif %}

## Admin Access

The admin interface is available at [https://admin.{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/ubooquity/admin](https://admin{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/ubooquity/admin)

Be sure to set an admin password after enabling the service.

{% if enable_tor %}
The admin interface is also available via Tor at [http://admin.{{ ubooquity.subdomain + "." + tor_domain }}/ubooquity/admin](http://admin.{{ ubooquity.subdomain + "." + tor_domain }}/ubooquity/admin)
{% endif %}
