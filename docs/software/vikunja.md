# Vikunja

[Vikunja](https://kolaente.dev/vikunja/) or [The official web page](https://vikunja.io/) The to-do app to organize your life

## Access

It is available at [https://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/](https://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/) or [http://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/](http://{% if vikunja.domain %}{{ vikunja.domain }}{% else %}{{ vikunja.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ vikunja.subdomain + "." + tor_domain }}/](http://{{ vikunja.subdomain + "." + tor_domain }}/)
{% endif %}