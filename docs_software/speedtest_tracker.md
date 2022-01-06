# Speedtest-Tracker

[Speedtest-Tracker](https://github.com/henrywhitaker3/Speedtest-Tracker) A tool to run periodic speedtests check every hour and graphs the results

## Access

It is available at [https://{% if speedtest_tracker.domain %}{{ speedtest_tracker.domain }}{% else %}{{ speedtest_tracker.subdomain + "." + domain }}{% endif %}/](https://{% if speedtest_tracker.domain %}{{ speedtest_tracker.domain }}{% else %}{{ speedtest_tracker.subdomain + "." + domain }}{% endif %}/) or [http://{% if speedtest_tracker.domain %}{{ speedtest_tracker.domain }}{% else %}{{ speedtest_tracker.subdomain + "." + domain }}{% endif %}/](http://{% if speedtest_tracker.domain %}{{ speedtest_tracker.domain }}{% else %}{{ speedtest_tracker.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ speedtest_tracker.subdomain + "." + tor_domain }}/](http://{{ speedtest_tracker.subdomain + "." + tor_domain }}/)
{% endif %}
