# Drone

[Drone](https://drone.io) is a self-service continuous delivery platform

## Access

It is available at [https://{% if drone.domain %}{{ drone.domain }}{% else %}{{ drone.subdomain + "." + domain }}{% endif %}/](https://{% if drone.domain %}{{ drone.domain }}{% else %}{{ drone.subdomain + "." + domain }}{% endif %}/) or [http://{% if drone.domain %}{{ drone.domain }}{% else %}{{ drone.subdomain + "." + domain }}{% endif %}/](http://{% if drone.domain %}{{ drone.domain }}{% else %}{{ drone.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ drone.subdomain + "." + tor_domain }}/](http://{{ drone.subdomain + "." + tor_domain }}/)
{% endif %}
