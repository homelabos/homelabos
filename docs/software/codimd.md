# CodiMD

[CodiMD](https://demo.codimd.org/) The best platform to write and share markdown

## Access

It is available at [https://codimd.{{ domain }}/](https://codimd.{{ domain }}/) or [http://codimd.{{ domain }}/](http://codimd.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://codimd.{{ tor_domain }}/](http://codimd.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

codimd:
  https_only: True
  auth: True