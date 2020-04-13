# Grownetics

[Grownetics](https://grownetics.com/) is an open source environmental mapping with plant management and tracking software suite.

## Setup

To create the database run `docker exec -it grownetics_growdash_1 ./seed.sh`.

## Access

It is available at [https://grownetics.{{ domain }}/](https://grownetics.{{ domain }}/) or [http://grownetics.{{ domain }}/](http://grownetics.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://grownetics.{{ tor_domain }}/](http://grownetics.{{ tor_domain }}/)
{% endif %}
