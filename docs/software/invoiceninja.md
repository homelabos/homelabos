# Invoice Ninja

[Invoice Ninja](https://www.invoiceninja.org/) Free Open-Source Invoicing

## Access

It is available at [https://{% if invoiceninja.domain %}{{ invoiceninja.domain }}{% else %}{{ invoiceninja.subdomain + "." + domain }}{% endif %}/](https://{% if invoiceninja.domain %}{{ invoiceninja.domain }}{% else %}{{ invoiceninja.subdomain + "." + domain }}{% endif %}/) or [http://{% if invoiceninja.domain %}{{ invoiceninja.domain }}{% else %}{{ invoiceninja.subdomain + "." + domain }}{% endif %}/](http://{% if invoiceninja.domain %}{{ invoiceninja.domain }}{% else %}{{ invoiceninja.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ invoiceninja.subdomain + "." + tor_domain }}/](http://{{ invoiceninja.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
invoiceninja:
  https_only: True
  auth: True
```
