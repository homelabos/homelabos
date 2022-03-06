# Internet Monitoring

[Internet Monitoring](https://github.com/geerlingguy/internetmonitoring-pi/tree/master/internetmonitoring-monitoring) 

Internet Monitoring Docker Stack for tracking speed and ping over time with Prometheus + Grafana

**Supported Architectures:** amd64

## Setup

To enable Internet Monitoring, run the following command:

**`make set internetmonitoring.enable true`**

To finalise any changes made, please run:

**`make update_one internetmonitoring`**

## Admin access

admin (Password stored in passwords folder, `internetmonitor_grafana_passwd`)

## Access

Internet Monitoring is available at [https://{% if internetmonitoring.domain %}{{ internetmonitoring.domain }}{% else %}{{ internetmonitoring.subdomain + "." + domain }}{% endif %}/](https://{% if internetmonitoring.domain %}{{ internetmonitoring.domain }}{% else %}{{ internetmonitoring.subdomain + "." + domain }}{% endif %}/) or [http://{% if internetmonitoring.domain %}{{ internetmonitoring.domain }}{% else %}{{ internetmonitoring.subdomain + "." + domain }}{% endif %}/](http://{% if internetmonitoring.domain %}{{ internetmonitoring.domain }}{% else %}{{ internetmonitoring.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ internetmonitoring.subdomain + "." + tor_domain }}/](http://{{ internetmonitoring.subdomain + "." + tor_domain }}/)
{% endif %}
