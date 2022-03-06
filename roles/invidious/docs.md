# Invidious

[Invidious](https://github.com/iv-org/invidious/) Invidious is an alternative front-end to YouTube

## Access

It is available at [https://{% if invidious.domain %}{{ invidious.domain }}{% else %}{{ invidious.subdomain + "." + domain }}{% endif %}/](https://{% if invidious.domain %}{{ invidious.domain }}{% else %}{{ invidious.subdomain + "." + domain }}{% endif %}/) or [http://{% if invidious.domain %}{{ invidious.domain }}{% else %}{{ invidious.subdomain + "." + domain }}{% endif %}/](http://{% if invidious.domain %}{{ invidious.domain }}{% else %}{{ invidious.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ invidious.subdomain + "." + tor_domain }}/](http://{{ invidious.subdomain + "." + tor_domain }}/)
{% endif %}
