# NextCloud

[NextCloud](https://nextcloud.com/) is your Dropbox / Google Calendar replacement.

## Configuration

When creating the admin account, expand the `Storage & Database` tab, select `MySQL/MariaDB`, then fill out the following information.

Database User: `nextcloud`
Database Password: `nextcloud`
Database Name: `nextcloud`
Change `localhost` to `nextcloud_db`

Hit `Finish Setup`

## Access

It is available at [https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/) or [http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nextcloud.subdomain + "." + tor_domain }}/](http://{{ nextcloud.subdomain + "." + tor_domain }}/)
{% endif %}
