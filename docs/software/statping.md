# Statping

[Statping](https://github.com/statping/statping) Web and App Status Monitoring for Any Type of Project

## Access

It is available at [https://statping.{{ domain }}/](https://statping.{{ domain }}/) or [http://statping.{{ domain }}/](http://statping.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://statping.{{ tor_domain }}/](http://statping.{{ tor_domain }}/)
{% endif %}

To login, click on 'Dashboard' at the end of the page.
A default username and password named 'admin' is generated on first start, please change them.


## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

statping:
  https_only: True
  auth: True
