# Huginn

[Huginn](https://github.com/huginn/huginn) Create agents that monitor and act on your behalf. Your agents are standing by!

## Access

It is available at [https://huginn.{{ domain }}/](https://huginn.{{ domain }}/) or [http://huginn.{{ domain }}/](http://huginn.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://huginn.{{ tor_domain }}/](http://huginn.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

huginn:
  https_only: True
  auth: True