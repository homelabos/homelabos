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

## Post Install work

You'll want to create a user, and import city data. To do that ssh to your server and execute these commands

- `docker exec pixelfed_pixelfed_1 /bin/bash' - This will give you a shell to run the following commands
- `php artisan user:create` - follow the prompts, ensure it's an admin user
- `php artisan import:cities'
- 'exit' - To exit the docker shell

## Access

pixelfed is available at [https://{% if pixelfed.domain %}{{ pixelfed.domain }}{% else %}{{ pixelfed.subdomain + "." + domain }}{% endif %}/](https://{% if pixelfed.domain %}{{ pixelfed.domain }}{% else %}{{ pixelfed.subdomain + "." + domain }}{% endif %}/) or [http://{% if pixelfed.domain %}{{ pixelfed.domain }}{% else %}{{ pixelfed.subdomain + "." + domain }}{% endif %}/](http://{% if pixelfed.domain %}{{ pixelfed.domain }}{% else %}{{ pixelfed.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ pixelfed.subdomain + "." + tor_domain }}/](http://{{ pixelfed.subdomain + "." + tor_domain }}/)
{% endif %}
