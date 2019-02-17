# airsonic

[Airsonic](https://airsonic.github.io/) is a free, web-based media streamer, providing ubiquitous access to your music.

## Access

It is available at [https://airsonic.{{ domain }}/](https://airsonic.{{ domain }}/) or [http://airsonic.{{ domain }}/](http://airsonic.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://airsonic.{{ tor_domain }}/](http://airsonic.{{ tor_domain }}/)
{% endif %}
