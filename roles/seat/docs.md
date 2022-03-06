# SEaT

[SEaT](https://github.com/eveseat/seat) A Simple, EVE Online API Tool and Corporation Manager 

## Setup

After everything starts up for the first time, run: `docker exec -it seat_seat-web_1 php artisan key:generate --show`.
Paste that into your `settings/config.yml` as the `seat.app_key`.
Update the service `make update_one seat`

## Access

It is available at [https://{% if seat.domain %}{{ seat.domain }}{% else %}{{ seat.subdomain + "." + domain }}{% endif %}/](https://{% if seat.domain %}{{ seat.domain }}{% else %}{{ seat.subdomain + "." + domain }}{% endif %}/) or [http://{% if seat.domain %}{{ seat.domain }}{% else %}{{ seat.subdomain + "." + domain }}{% endif %}/](http://{% if seat.domain %}{{ seat.domain }}{% else %}{{ seat.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ seat.subdomain + "." + tor_domain }}/](http://{{ seat.subdomain + "." + tor_domain }}/)
{% endif %}
