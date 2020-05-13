# Homedash

[Homedash](https://lamarios.github.io/Homedash2/) is a simple dashboard that allows to monitor and interact with many different services.

## Access

It is available at [https://{% if homedash.domain %}{{ homedash.domain }}{% else %}{{ homedash.subdomain + "." + domain }}{% endif %}/](https://{% if homedash.domain %}{{ homedash.domain }}{% else %}{{ homedash.subdomain + "." + domain }}{% endif %}/) or [http://{% if homedash.domain %}{{ homedash.domain }}{% else %}{{ homedash.subdomain + "." + domain }}{% endif %}/](http://{% if homedash.domain %}{{ homedash.domain }}{% else %}{{ homedash.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ homedash.subdomain + "." + tor_domain }}/](http://{{ homedash.subdomain + "." + tor_domain }}/)
{% endif %}
