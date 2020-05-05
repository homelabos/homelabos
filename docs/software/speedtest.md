# Speedtest

[Speedtest](https://github.com/atribe/Speedtest-for-InfluxDB-and-Grafana) A tool to run periodic speedtests and save them in InfluxDB for graphing in Grafana

## Access

It is available at [https://{% if speedtest.domain %}{{ speedtest.domain }}{% else %}{{ speedtest.subdomain + "." + domain }}{% endif %}/](https://{% if speedtest.domain %}{{ speedtest.domain }}{% else %}{{ speedtest.subdomain + "." + domain }}{% endif %}/) or [http://{% if speedtest.domain %}{{ speedtest.domain }}{% else %}{{ speedtest.subdomain + "." + domain }}{% endif %}/](http://{% if speedtest.domain %}{{ speedtest.domain }}{% else %}{{ speedtest.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ speedtest.subdomain + "." + tor_domain }}/](http://{{ speedtest.subdomain + "." + tor_domain }}/)
{% endif %}
