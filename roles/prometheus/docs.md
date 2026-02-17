# Prometheus

[Prometheus](https://prometheus.io/) is an open-source systems monitoring and alerting toolkit.

This role includes a default scrape configuration for Prometheus itself and HomelabOS Traefik metrics.

## Access

It is available at [https://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/](https://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/) or [http://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/](http://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/)

It is also available directly on the host at `http://{{ homelab_ip }}:9090`.

{% if enable_tor %}
It is also available via Tor at [http://{{ prometheus.subdomain + "." + tor_domain }}/](http://{{ prometheus.subdomain + "." + tor_domain }}/)
{% endif %}
