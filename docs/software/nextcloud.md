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

It is available at [https://nextcloud.{{ domain }}/](https://nextcloud.{{ domain }}/) or [http://nextcloud.{{ domain }}/](http://nextcloud.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://nextcloud.{{ tor_domain }}/](http://nextcloud.{{ tor_domain }}/)
{% endif %}
