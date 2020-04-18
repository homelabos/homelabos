# Zulip

[Zulip](https://github.com/zulip/zulip) is a threaded chat service.

## Setup

[https://github.com/zulip/docker-zulip](https://github.com/zulip/docker-zulip)

## Access

It is available at [https://zulip.{{ domain }}/](https://zulip.{{ domain }}/) or [http://zulip.{{ domain }}/](http://zulip.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://zulip.{{ tor_domain }}/](http://zulip.{{ tor_domain }}/)
{% endif %}
