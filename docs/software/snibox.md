# Snibox

[Snibox](https://snibox.github.io/) Self-hosted snippet manager. Developed to collect and organize code snippets.

## Access

It is available at [https://{% if snibox.domain %}{{ snibox.domain }}{% else %}{{ snibox.subdomain + "." + domain }}{% endif %}/](https://{% if snibox.domain %}{{ snibox.domain }}{% else %}{{ snibox.subdomain + "." + domain }}{% endif %}/) or [http://{% if snibox.domain %}{{ snibox.domain }}{% else %}{{ snibox.subdomain + "." + domain }}{% endif %}/](http://{% if snibox.domain %}{{ snibox.domain }}{% else %}{{ snibox.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ snibox.subdomain + "." + tor_domain }}/](http://{{ snibox.subdomain + "." + tor_domain }}/)
{% endif %}
