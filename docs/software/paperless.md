# Paperless

[Paperless](https://github.com/danielquinn/paperless) is a document management server. Point it at a folder on your NAS that your scanner is set to scan to, scan all your paper docs, have a searchable secure document archive.

## Access

It is available at [https://paperless.{{ domain }}/](https://paperless.{{ domain }}/) or [http://paperless.{{ domain }}/](http://paperless.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://paperless.{{ tor_domain }}/](http://paperless.{{ tor_domain }}/)
{% endif %}

## Create user
To create a user, ssh into your server and run `docker-compose run paperless createsuperuser`. You will be prompted to enter a username, email (optional) and password.