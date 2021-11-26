# Vikunja

[Vikunja](https://vikunja.io/) (or [source cde](https://kolaente.dev/vikunja/)) is the to-do app to organize your life

## Access

By defualt new user registration has been disabled. To modify that change `VIKUNJA_SERVICE_ENABLEREGISTRATION` in the docker-compose file from `"false"` to `"true"`.

There is no default user or password. You only need to register a new account and set all the details when creating it.

Remember to change `VIKUNJA_SERVICE_ENABLEREGISTRATION` back to `"false"` after you have registered the account for yourself.

----

It is available at [https://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/](https://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/) or [http://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/](http://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ vikunja.subdomain + "." + tor_domain }}/](http://{{ vikunja.subdomain + "." + tor_domain }}/)
{% endif %}