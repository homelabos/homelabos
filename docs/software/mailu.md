# Mailu

[Mailu](https://mailu.io/1.7/general.html) is a simple yet full-featured mail server as a set of Docker images.

## Access

It is available at [https://mailu.{{ domain }}/](https://mailu.{{ domain }}/) or [http://mailu.{{ domain }}/](http://mailu.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://mailu.{{ tor_domain }}/](http://mailu.{{ tor_domain }}/)
{% endif %}

## Admin Access

It is available at [https://admin.mailu.{{ domain }}/ui/](https://admin.mailu.{{ domain }}/ui/) or [http://admin.mailu.{{ domain }}/ui/](http://admin.mailu.{{ domain }}/ui/)

{% if enable_tor %}
It is also available via Tor at [http://admin.mailu.{{ tor_domain }}/ui/](http://admin.mailu.{{ tor_domain }}/ui/)
{% endif %}

You can login using admin@{{ domain }} and the password found on your server in `/var/homelabos/mailu/.env` under INITIAL_ADMIN_PW, or in `settings/passwords/mailu_admin_password` from your deploy location.

## Creating Users

You can create users in the admin interface, by clicking `Mail Domains` on the main menu, then the envelope icon next to your mail domain.

Users can then also login to the admin interface, but will only be able to adjunt their password and spam settings.
