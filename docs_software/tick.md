# TICK

Enabling the TICK stack enables Telegraf, [InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/), Chronograf, and Kapacitor.

[InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) is the Time Series Database that Telefgraf writes to and [Grafana](software/grafana) can visualize.

It can also take data from [Home Assistant](/software/homeassistant) and many other sources.

## Access

Authentication is turned on for default for TICK because Chronograf has no authentication. Login with the default HomelabOS username and password.

It is available at [https://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/](https://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/) or [http://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/](http://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ airsonic.subdomain + "." + tor_domain }}/](http://{{ airsonic.subdomain + "." + tor_domain }}/)
{% endif %}