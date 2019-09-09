# Speedtest

[Speedtest](https://github.com/atribe/Speedtest-for-InfluxDB-and-Grafana) A tool to run periodic speedtests and save them in InfluxDB for graphing in Grafana

## Access

It is available at [https://speedtest.{{ domain }}/](https://speedtest.{{ domain }}/) or [http://speedtest.{{ domain }}/](http://speedtest.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://speedtest.{{ tor_domain }}/](http://speedtest.{{ tor_domain }}/)
{% endif %}
