# Gitea

[Gitea](https://gitea.io/en-US/) is a Git hosting platform.

## Access

It is available at [https://git.{{ domain }}/](https://git.{{ domain }}/) or [http://git.{{ domain }}/](http://git.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://git.{{ tor_domain }}/](http://git.{{ tor_domain }}/)
{% endif %}
