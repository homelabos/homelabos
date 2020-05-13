# Zulip

[Zulip](https://github.com/zulip/zulip) is a threaded chat service.

## Setup

[https://github.com/zulip/docker-zulip](https://github.com/zulip/docker-zulip)

## Access

It is available at [https://{% if zulip.domain %}{{ zulip.domain }}{% else %}{{ zulip.subdomain + "." + domain }}{% endif %}/](https://{% if zulip.domain %}{{ zulip.domain }}{% else %}{{ zulip.subdomain + "." + domain }}{% endif %}/) or [http://{% if zulip.domain %}{{ zulip.domain }}{% else %}{{ zulip.subdomain + "." + domain }}{% endif %}/](http://{% if zulip.domain %}{{ zulip.domain }}{% else %}{{ zulip.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ zulip.subdomain + "." + tor_domain }}/](http://{{ zulip.subdomain + "." + tor_domain }}/)
{% endif %}
