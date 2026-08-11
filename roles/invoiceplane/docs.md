# InvoicePlane

[InvoicePlane](https://www.invoiceplane.com/) is a self-hosted application for managing quotes, invoices, clients, and payments.

## Configuration

InvoicePlane opens its setup wizard on first launch. Complete the wizard using the preconfigured database values:

```
Database host: invoiceplane_db
Database name: invoiceplane
Database user: invoiceplane
Database password: See settings/passwords/invoiceplane_db_password
```

After the setup wizard is completed, the container automatically disables the setup wizard on the next restart.

To install e-invoice templates on startup, set `invoiceplane.install_einvoice_templates` to a comma-separated list such as `zugferd-extended,facturx`.

## Access

It is available at [https://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/](https://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/) or [http://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/](http://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ invoiceplane.subdomain + "." + tor_domain }}/](http://{{ invoiceplane.subdomain + "." + tor_domain }}/)
{% endif %}
