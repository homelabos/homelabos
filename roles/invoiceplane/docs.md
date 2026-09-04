# InvoicePlane

[InvoicePlane](https://www.invoiceplane.com/) is a self-hosted application for managing quotes, invoices, clients, and payments.

## Configuration

The first-run setup wizard is automated by the role: the application image
pre-populates `ipconfig.php` (database credentials + URL) from its `IP_DB_*` /
`IP_URL` environment variables at startup, and the role creates the schema and
admin user automatically. No manual setup is required.

This automation gates on the database state (idempotent): a database without
the `ip_users` table runs the full setup wizard; one that already has it gets
`SETUP_COMPLETED=true` re-asserted so the app never lands on the `/welcome`
landing page after a container recreate. The admin user is created with the
given email and name (defaulting to `admin_email` / `default_username`), with a
password generated into `settings/passwords/invoiceplane_admin_password`.

To re-run setup from scratch, wipe the database volume and re-deploy.

To install e-invoice templates on startup, set `invoiceplane.install_einvoice_templates` to a comma-separated list such as `zugferd-extended,facturx`.

## Access

It is available at [https://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/](https://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/) or [http://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/](http://{% if invoiceplane.domain %}{{ invoiceplane.domain }}{% else %}{{ invoiceplane.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ invoiceplane.subdomain + "." + tor_domain }}/](http://{{ invoiceplane.subdomain + "." + tor_domain }}/)
{% endif %}
