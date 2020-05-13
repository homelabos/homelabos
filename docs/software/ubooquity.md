# Ubooquity

[Ubooquity](https://vaemendis.net/ubooquity/) Ubooquity is a free home server for your comics and ebooks library

## Access

It is available at [https://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/](https://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/) or [http://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/](http://{% if ubooquity.domain %}{{ ubooquity.domain }}{% else %}{{ ubooquity.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ubooquity.subdomain + "." + tor_domain }}/](http://{{ ubooquity.subdomain + "." + tor_domain }}/)
{% endif %}
