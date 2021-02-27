# The Spaghetti Detective

[The Spaghetti Detective](https://thespaghettidetective.com) AI-based failure detection for 3D printer remote management and monitoring.

## Setup

### Login as Django admin

1. Open Django admin page at `http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}your_server_ip{% endif %}/admin/`

2. Login with username `root@example.com`, password `supersecret`. Once logged in, you can optionally (but highly encouraged to) change the admin password using this link: `http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}your_server_ip{% endif %}/admin/app/user/1/password/`.

### Configure Django site

1. On Django admin page, click "Sites", and click the only entry "example.com" to bring up the site you need to configure. Change "Domain name" to `your_server_ip:3334`. No "http://", "https://" prefix or trailing "/", otherwise it will NOT work.

2. Click "Save". Yes it's correct that Django is not as smart as most people think. ;)

![Site configuration](https://raw.githubusercontent.com/TheSpaghettiDetective/TheSpaghettiDetective/master/docs/site_config.png)

## Access

It is available at [https://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/](https://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/) or [http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/](http://{% if thespaghettidetective.domain %}{{ thespaghettidetective.domain }}{% else %}{{ thespaghettidetective.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ thespaghettidetective.subdomain + "." + tor_domain }}/](http://{{ thespaghettidetective.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
thespaghettidetective:
  https_only: True
  auth: True
```
