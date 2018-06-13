# InfluxDB

[InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) is the Time Series Database that [Darksky](/software/darksky) writes to and [Grafana](/software/grafana) can visualize.

It can also take data from [Home Assistant](/software/homeassistant) and many other sources.

## Access

There is no direct access, but you can access it in Grafana by creating a new InfluxDB data source pointing at host `influxdb`.