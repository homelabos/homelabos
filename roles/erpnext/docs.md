# ERPNext

[ERPNext](https://erpnext.com) is a free and open source Enterprise Resource Planning (ERP) system built on the Frappe framework. It covers accounting, HR, CRM, manufacturing, project management, and more.

## Access

It is available at [https://{% if erpnext.domain %}{{ erpnext.domain }}{% else %}{{ erpnext.subdomain + "." + domain }}{% endif %}/](https://{% if erpnext.domain %}{{ erpnext.domain }}{% else %}{{ erpnext.subdomain + "." + domain }}{% endif %}/) or [http://{% if erpnext.domain %}{{ erpnext.domain }}{% else %}{{ erpnext.subdomain + "." + domain }}{% endif %}/](http://{% if erpnext.domain %}{{ erpnext.domain }}{% else %}{{ erpnext.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ erpnext.subdomain + "." + tor_domain }}/](http://{{ erpnext.subdomain + "." + tor_domain }}/)
{% endif %}

## Credentials

Default credentials after first site creation:
- **Username:** `Administrator`
- **Password:** Set via `erpnext.admin_password` in settings/config.yml

## Initial Setup

ERPNext ships with sensible defaults. On first deploy, site creation runs automatically as part of the Docker Compose startup via the `create-site` service. This is a one-time process - once the site is created, the `create-site` service will fail to run again (expected behavior).

To create additional sites or manage the system, exec into the backend container:

```bash
docker exec -it erpnext_backend_1 bash
bench new-site site2.example.com
```

## Upgrades

Upgrades happen automatically when you update the `erpnext.version` setting. The container images from frappe/erpnext track the official releases on Docker Hub.
