# MassiveDecks

[MassiveDecks](https://github.com/Lattyware/massivedecks/blob/master/README.md) Massive Decks is a comedy party game based on Cards against Humanity. Play with friends! It works great with a bunch of people in the same room on phones, or on voice chat online.

## Access

It is available at [https://massivedecks.{{ domain }}/](https://massivedecks.{{ domain }}/) or [http://massivedecks.{{ domain }}/](http://massivedecks.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://massivedecks.{{ tor_domain }}/](http://massivedecks.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

massivedecks:
  https_only: True
  auth: True