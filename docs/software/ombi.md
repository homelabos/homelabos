# Ombi

[Ombi](https://ombi.io) Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves!

## Access

It is available at [https://{% if ombi.domain %}{{ ombi.domain }}{% else %}{{ ombi.subdomain + "." + domain }}{% endif %}/](https://{% if ombi.domain %}{{ ombi.domain }}{% else %}{{ ombi.subdomain + "." + domain }}{% endif %}/) or [http://{% if ombi.domain %}{{ ombi.domain }}{% else %}{{ ombi.subdomain + "." + domain }}{% endif %}/](http://{% if ombi.domain %}{{ ombi.domain }}{% else %}{{ ombi.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ombi.subdomain + "." + tor_domain }}/](http://{{ ombi.subdomain + "." + tor_domain }}/)
{% endif %}
