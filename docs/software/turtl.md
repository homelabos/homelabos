# Turtl

[Turtl](https://github.com/turtl/server) Turtl is a note taking app with desktop and mobile apps.

## Access


It is available at [https://{% if turtl.domain %}{{ turtl.domain }}{% else %}{{ turtl.subdomain + "." + domain }}{% endif %}/](https://{% if turtl.domain %}{{ turtl.domain }}{% else %}{{ turtl.subdomain + "." + domain }}{% endif %}/) or [http://{% if turtl.domain %}{{ turtl.domain }}{% else %}{{ turtl.subdomain + "." + domain }}{% endif %}/](http://{% if turtl.domain %}{{ turtl.domain }}{% else %}{{ turtl.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://turtl.{{ tor_domain }}/](http://turtl.{{ tor_domain }}/)
{% endif %}

You must then download a desktop client or Android or iOS app. Get the newest version here <https://github.com/turtl/desktop/releases>

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

turtl:
  https_only: True
  auth: True

This is strongly recommended.
