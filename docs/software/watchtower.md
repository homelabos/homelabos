# Watchtower

[Watchtower](https://containrrr.github.io/watchtower/) A process for automating Docker container base image updates

## Access

It is available at [https://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/](https://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/) or [http://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/](http://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ watchtower.subdomain + "." + tor_domain }}/](http://{{ watchtower.subdomain + "." + tor_domain }}/)
{% endif %}
