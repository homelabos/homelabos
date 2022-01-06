# Unifi Controller

[Unifi Controller](https://www.ui.com/) The Unifi-controller Controller software is a powerful, enterprise wireless software engine ideal for high-density client deployments requiring low latency and high uptime performance.

## Access

It is available at [https://unificontroller.{{ domain }}/](https://unificontroller.{{ domain }}/) or [http://unificontroller.{{ domain }}/](http://unificontroller.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://unificontroller.{{ tor_domain }}/](http://unificontroller.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
unificontroller:
  https_only: True
  auth: True
```
