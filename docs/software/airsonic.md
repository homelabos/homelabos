# airsonic

[Airsonic](https://airsonic.github.io/) is a free, web-based media streamer, providing ubiquitous access to your music.

## Access

It is available at [https://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/](https://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/) or [http://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/](http://{% if airsonic.domain %}{{ airsonic.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ airsonic.subdomain + "." + tor_domain }}/](http://{{ airsonic.subdomain + "." + tor_domain }}/)
{% endif %}
