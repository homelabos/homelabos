# Koel

[Koel](https://koel.phanan.net/) is a personal music streaming server that works.

## Setup

To set your credentials, ssh in to your machine and run: `docker exec -it homelabos_koel_1 php artisan koel:init`

Or open [Portainer](portainer.md) and run `php artisan koel:init`

## Access

The dashboard is available at [https://koel.{{ domain }}/](https://koel.{{ domain }}/) or [http://koel.{{ domain }}/](http://koel.{{ domain }}/)

It is also available via Tor at [http://koel.{{ tor_domain }}/](http://koel.{{ tor_domain }}/)