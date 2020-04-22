# ERPNext

[ERPNext](https://github.com/frappe/frappe_docker) Open Source ERP for Everyone.

## Setup

On your server run:

```
chmod -R 777 /var/homelabos/erpnext/
```

then

```
docker exec -it -e "SITE_NAME=erpnext.{{ domain }}" -e "SITES=erpnext.{{ domain }}" -e "ADMIN_PASSWORD=PASS" -e "INSTALL_APPS=erpnext" -e "FORCE=1" erpnext_erpnext-python_1 docker-entrypoint.sh new
```

## Access

It is available at [https://erpnext.{{ domain }}/](https://erpnext.{{ domain }}/) or [http://erpnext.{{ domain }}/](http://erpnext.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://erpnext.{{ tor_domain }}/](http://erpnext.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

erpnext:
  https_only: True
  auth: True