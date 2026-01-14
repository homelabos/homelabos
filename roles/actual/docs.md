# Actual Budget

[Actual Budget](https://actualbudget.org/) is a local-first personal finance app.

## Access

The dashboard is available at [https://{% if actual.domain %}{{ actual.domain }}{% else %}{{ actual.subdomain + "." + domain }}{% endif %}/](https://{% if actual.domain %}{{ actual.domain }}{% else %}{{ actual.subdomain + "." + domain }}{% endif %}/) or [http://{% if actual.domain %}{{ actual.domain }}{% else %}{{ actual.subdomain + "." + domain }}{% endif %}/](http://{% if actual.domain %}{{ actual.domain }}{% else %}{{ actual.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ actual.subdomain + "." + tor_domain }}/](http://{{ actual.subdomain + "." + tor_domain }}/)
{% endif %}
