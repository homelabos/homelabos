# Xteve

[Xteve](https://xteve.de/) is an emulated TV Tuner for IPTV services. It offers guide management and smart filtering of channels from your IPTV provider.

## Configuration

To make either xteve or Radarr work, you need to configure an
Indexer and a Downlad Client.

## Access

Xteve available at [https://{% if xteve.domain %}{{ xteve.domain }}{% else %}{{ xteve.subdomain + "." + domain }}{% endif %}/web](https://{% if xteve.domain %}{{ xteve.domain }}{% else %}{{ xteve.subdomain + "." + domain }}{% endif %}/web) or [http://{% if xteve.domain %}{{ xteve.domain }}{% else %}{{ xteve.subdomain + "." + domain }}{% endif %}/web](http://{% if xteve.domain %}{{ xteve.domain }}{% else %}{{ xteve.subdomain + "." + domain }}{% endif %}/web)

{% if enable_tor %}
It is also available via Tor at [http://{{ xteve.subdomain + "." + tor_domain }}/](http://{{ xteve.subdomain + "." + tor_domain }}/)
{% endif %}
