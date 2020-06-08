# EtherCalc

[EtherCalc](https://ethercalc.net) EtherCalc is a web spreadsheet

## Access

It is available at [https://{% if ethercalc.domain %}{{ ethercalc.domain }}{% else %}{{ ethercalc.subdomain + "." + domain }}{% endif %}/](https://{% if ethercalc.domain %}{{ ethercalc.domain }}{% else %}{{ ethercalc.subdomain + "." + domain }}{% endif %}/) or [http://{% if ethercalc.domain %}{{ ethercalc.domain }}{% else %}{{ ethercalc.subdomain + "." + domain }}{% endif %}/](http://{% if ethercalc.domain %}{{ ethercalc.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ethercalc + "." + tor_domain }}/](http://{{ ethercalc + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
ethercalc:
  https_only: True
  auth: True
```
