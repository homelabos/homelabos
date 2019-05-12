# Grafana

[Grafana](https://grafana.com/) is a Time Series Database graphing application.

You can use it to visualize the Weather data imported by [influxdb_darksky](software/influxdb_darksky),
power, activity, and other data from [Home Assistant](software/homeassistant), and general server
information via Telegraf.

Grafana comes configured with a Dashboard and Datasource connected for you out of the box. This default
dash and datasource will only with if you have the [TICK](software/tick) stack enabled.

You can login with the default user and pass you setup for HomelabOS.

To reset the admin password run `docker exec -it grafana_grafana_1 grafana-cli admin reset-admin-password 12345`.

## Access

It is available at [https://grafana.{{ domain }}/](https://grafana.{{ domain }}/) or [http://grafana.{{ domain }}/](http://grafana.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://grafana.{{ tor_domain }}/](http://grafana.{{ tor_domain }}/)
{% endif %}
