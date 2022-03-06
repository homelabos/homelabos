# Searx

[Searx](https://github.com/asciimoo/searx/) A privacy-respecting, hackable metasearch engine.

## Access

It is available at [https://{% if searx.domain %}{{ searx.domain }}{% else %}{{ searx.subdomain + "." + domain }}{% endif %}/](https://{% if searx.domain %}{{ searx.domain }}{% else %}{{ searx.subdomain + "." + domain }}{% endif %}/) or [http://{% if searx.domain %}{{ searx.domain }}{% else %}{{ searx.subdomain + "." + domain }}{% endif %}/](http://{% if searx.domain %}{{ searx.domain }}{% else %}{{ searx.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ searx.subdomain + "." + tor_domain }}/](http://{{ searx.subdomain + "." + tor_domain }}/)
{% endif %}
