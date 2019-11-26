# Firefly III

[Firefly III](https://firefly-iii.org/) is a money management app.

The docker image comes from [jc5x/firefly-iii](https://hub.docker.com/r/jc5x/firefly-iii) and should support arm devices.
If you attempt to run it on arm and encounter issues,
[please see issue 478](https://gitlab.com/NickBusey/HomelabOS/-/issues/478)

## Access

It is available at [https://{% if firefly.domain %}{{ firefly.domain }}{% else %}{{ firefly.subdomain + "." + domain }}{% endif %}/](https://{% if firefly.domain %}{{ firefly.domain }}{% else %}{{ firefly.subdomain + "." + domain }}{% endif %}/) or [http://{% if firefly.domain %}{{ firefly.domain }}{% else %}{{ firefly.subdomain + "." + domain }}{% endif %}/](http://{% if firefly.domain %}{{ firefly.domain }}{% else %}{{ firefly.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ firefly.subdomain + "." + tor_domain }}/](http://{{ firefly.subdomain + "." + tor_domain }}/)
{% endif %}
