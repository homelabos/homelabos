# Pixelfed

[Pixelfed](https://pixelfed.org/) is a free and ethical photo sharing platform, powered by ActivityPub federation.

## Configuration

### Environment variables

Adjust the environment variables (roles/pixelfed/templates/pixelfed.env.j2) to match your needs.

More information about the possible options are available here: [Pixelfed Configuration](https://docs.pixelfed.org/master/)

### Setup

This once requires some manual setup, unfortunately.

- Connect to the server with ssh
- As soon as the **db and the app started completely** run `docker exec pixelfed_pixelfed_1 gosu www-data:www-data php artisan migrate --force`. This will do the database migrations.
  - **Note:** When you start the service for the first time, the mariadb container needs to do some initial configuration and thus needs a bit longer to start completely.
- Now the configuration is complete and the service is available

**Note:**
- Currently, there exists no official docker image of this software, because of this the build will be run on the server with the official git repository as build context. Be aware that this build will take about 15 minutes depending on the machine and it also results in a high CPU usage during the build time.

## Access

pixelfed is available at [https://pixelfed.{{ domain }}/](https://pixelfed.{{ domain }}/) or [http://pixelfed.{{ domain }}/](http://pixelfed.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://pixelfed.{{ tor_domain }}/](http://pixelfed.{{ tor_domain }}/)
{% endif %}
