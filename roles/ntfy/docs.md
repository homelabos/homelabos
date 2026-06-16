# ntfy

[ntfy](https://ntfy.sh) is a simple HTTP-based pub-sub notification service. It allows you to send push notifications to your phone or desktop via scripts from any computer.

## Access

It is available at [https://{% if ntfy.domain %}{{ ntfy.domain }}{% else %}{{ ntfy.subdomain + "." + domain }}{% endif %}/](https://{% if ntfy.domain %}{{ ntfy.domain }}{% else %}{{ ntfy.subdomain + "." + domain }}{% endif %}/) or [http://{% if ntfy.domain %}{{ ntfy.domain }}{% else %}{{ ntfy.subdomain + "." + domain }}{% endif %}/](http://{% if ntfy.domain %}{{ ntfy.domain }}{% else %}{{ ntfy.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ntfy.subdomain + "." + tor_domain }}/](http://{{ ntfy.subdomain + "." + tor_domain }}/)
{% endif %}

## Usage

Send a notification via curl:
```bash
curl -u user:pass -d "Backup complete" https://{{ ntfy.subdomain + "." + domain }}/mytopic
```

Subscribe via the web app at the service URL, or use the ntfy mobile app by adding your server as a custom host.

## Configuration

Edit `ntfy.server.yml` in the service data directory (`{{ volumes_root }}/ntfy/`) to configure authentication, rate limiting, and other server options. The container will pick up changes after a restart.
