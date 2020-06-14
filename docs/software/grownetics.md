# Grownetics

[Grownetics](https://grownetics.co/) is an open source environmental mapping with plant management and tracking software suite.

The docker images comes from multiple sources and some of them do not support arm devices. 
If you are aware of a suitable substitution or replacement,
 [please see issue 478](https://gitlab.com/NickBusey/HomelabOS/-/issues/478) 
and test your idea using the [documentation](https://homelabos.com/docs/development/adding_services/).

## Setup

To create the database run `docker exec -it grownetics_growdash_1 ./seed.sh`.

Login with default credentials:

User: `admin@grownetics.co`

Pass: `GrowBetter16`

## Access

It is available at [https://{% if grownetics.domain %}{{ grownetics.domain }}{% else %}{{ grownetics.subdomain + "." + domain }}{% endif %}/](https://{% if grownetics.domain %}{{ grownetics.domain }}{% else %}{{ grownetics.subdomain + "." + domain }}{% endif %}/) or [http://{% if grownetics.domain %}{{ grownetics.domain }}{% else %}{{ grownetics.subdomain + "." + domain }}{% endif %}/](http://{% if grownetics.domain %}{{ grownetics.domain }}{% else %}{{ grownetics.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ grownetics.subdomain + "." + tor_domain }}/](http://{{ grownetics.subdomain + "." + tor_domain }}/)
{% endif %}
