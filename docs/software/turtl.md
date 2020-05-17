# Turtl

[Turtl](https://github.com/turtl/server) Turtl is a note takng app with desktop and mobile apps.

## Access

The server is available at [https://turtl.{{ domain }}/](https://turtl.{{ domain }}/) or [http://turtl.{{ domain }}/](http://turtl.{{ domain }}/)

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
