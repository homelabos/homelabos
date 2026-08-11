# frigate

[Frigate](https://frigate.video/) is an NVR with realtime object detection for IP cameras.

The docker image comes from [ghcr.io/blakeblackshear/frigate](https://ghcr.io/blakeblackshear/frigate).

## Access

It is available at [https://{% if frigate.domain %}{{ frigate.domain }}{% else %}{{ frigate.subdomain + "." + domain }}{% endif %}/](https://{% if frigate.domain %}{{ frigate.domain }}{% else %}{{ frigate.subdomain + "." + domain }}{% endif %}/) or [http://{% if frigate.domain %}{{ frigate.domain }}{% else %}{{ frigate.subdomain + "." + domain }}{% endif %}/](http://{% if frigate.domain %}{{ frigate.domain }}{% else %}{{ frigate.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ frigate.subdomain + "." + tor_domain }}/](http://{{ frigate.subdomain + "." + tor_domain }}/)
{% endif %}

## Configuration

Frigate requires a configuration file. Edit `{{ volumes_root }}/frigate/config/config.yml` with your camera and MQTT settings, then restart the service.
