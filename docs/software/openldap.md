# phpldapadmin

[docker-phpLDAPadmin](https://github.com/osixia/docker-phpLDAPadmin) provides LDAP.

## Access

It is available at [https://{% if openldap.domain %}{{ openldap.domain }}{% else %}{{ openldap.subdomain + "." + domain }}{% endif %}/](https://{% if openldap.domain %}{{ openldap.domain }}{% else %}{{ openldap.subdomain + "." + domain }}{% endif %}/) or [http://{% if openldap.domain %}{{ openldap.domain }}{% else %}{{ openldap.subdomain + "." + domain }}{% endif %}/](http://{% if openldap.domain %}{{ openldap.domain }}{% else %}{{ openldap.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ openldap.subdomain + "." + tor_domain }}/](http://{{ openldap.subdomain + "." + tor_domain }}/)
{% endif %}
