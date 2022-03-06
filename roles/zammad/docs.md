# Zammad

[Zammad](https://zammad.org/) Zammad is a web-based, open source user support/ticketing solution.

## Access

It is available at [https://zammad.{{ domain }}/](https://zammad.{{ domain }}/) or [http://zammad.{{ domain }}/](http://zammad.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://zammad.{{ tor_domain }}/](http://zammad.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
zammad:
  https_only: True
  auth: True
```

## Requirements Hardware

##### For Zammad and a database server like PostgreSQL we recommend at least:
 - 2 CPU cores
 - 4 GB of RAM (+4 GB if you want to run Elasticsearch on the same server)

##### For optimal performance up to 40 agents:
 - 4 CPU cores
 - 6 GB of RAM (+6 GB if you want to run Elasticsearch on the same server)

Of course at the end it depends on acutal load of concurent agents and data traffic.
