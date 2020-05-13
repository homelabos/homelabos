# FreshRSS

[FreshRSS](https://freshrss.org) is a free, self-hostable aggregator.

## Access

It is available at [https://{% if freshrss.domain %}{{ freshrss.domain }}{% else %}{{ freshrss.subdomain + "." + domain }}{% endif %}/](https://{% if freshrss.domain %}{{ freshrss.domain }}{% else %}{{ freshrss.subdomain + "." + domain }}{% endif %}/) or [http://{% if freshrss.domain %}{{ freshrss.domain }}{% else %}{{ freshrss.subdomain + "." + domain }}{% endif %}/](http://{% if freshrss.domain %}{{ freshrss.domain }}{% else %}{{ freshrss.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ freshrss.subdomain + "." + tor_domain }}/](http://{{ freshrss.subdomain + "." + tor_domain }}/)
{% endif %}
