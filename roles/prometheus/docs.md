# Prometheus

[Prometheus](https://prometheus.io/) is an open-source systems monitoring and alerting toolkit.

This role includes a default scrape configuration for Prometheus itself and HomelabOS Traefik metrics.

Host machine stats (CPU, memory, disk, and network) are collected by a bundled Node Exporter container
and scraped under the `node` job. These metrics are queryable directly in Prometheus and through the
Grafana Prometheus datasource.

## Access

It is available at [https://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/](https://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/) or [http://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/](http://{% if prometheus.domain %}{{ prometheus.domain }}{% else %}{{ prometheus.subdomain + "." + domain }}{% endif %}/)

It is also available directly on the host at `http://{{ homelab_ip }}:9090`.

{% if enable_tor %}
It is also available via Tor at [http://{{ prometheus.subdomain + "." + tor_domain }}/](http://{{ prometheus.subdomain + "." + tor_domain }}/)
{% endif %}
