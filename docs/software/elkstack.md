# ELK Stack

[ELK Stack](https://github.com/deviantony/docker-elk) Elastic Search, Logstash and Kibana

## Access

It is available at [https://elkstack.{{ domain }}/](https://elkstack.{{ domain }}/) or [http://elkstack.{{ domain }}/](http://elkstack.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://elkstack.{{ tor_domain }}/](http://elkstack.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

elkstack:
  https_only: True
  auth: True
