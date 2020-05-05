# Tautulli

[Tautulli](https://github.com/tautulli/tautulli) A Python based monitoring and tracking tool for Plex Media Server. 

## Access

It is available at [https://{% if tautulli.domain %}{{ tautulli.domain }}{% else %}{{ tautulli.subdomain + "." + domain }}{% endif %}/](https://{% if tautulli.domain %}{{ tautulli.domain }}{% else %}{{ tautulli.subdomain + "." + domain }}{% endif %}/) or [http://{% if tautulli.domain %}{{ tautulli.domain }}{% else %}{{ tautulli.subdomain + "." + domain }}{% endif %}/](http://{% if tautulli.domain %}{{ tautulli.domain }}{% else %}{{ tautulli.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ tautulli.subdomain + "." + tor_domain }}/](http://{{ tautulli.subdomain + "." + tor_domain }}/)
{% endif %}
