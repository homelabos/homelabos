# Digikam

[Digikam](https://www.digikam.org/) Professional Photo Management with the Power of Open Source

## Access

It is available at [https://{% if digikam.domain %}{{ digikam.domain }}{% else %}{{ digikam.subdomain + "." + domain }}{% endif %}/](https://{% if digikam.domain %}{{ digikam.domain }}{% else %}{{ digikam.subdomain + "." + domain }}{% endif %}/) or [http://{% if digikam.domain %}{{ digikam.domain }}{% else %}{{ digikam.subdomain + "." + domain }}{% endif %}/](http://{% if digikam.domain %}{{ digikam.domain }}{% else %}{{ digikam.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ digikam.subdomain + "." + tor_domain }}/](http://{{ digikam.subdomain + "." + tor_domain }}/)
{% endif %}
