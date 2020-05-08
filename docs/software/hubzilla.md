# Hubzilla

[Hubzilla](https://framagit.org/hubzilla) is a powerful platform for creating interconnected websites featuring a [decentralized/nomadic identity](https://zotlabs.org/page/hubzilla/hubzilla-project).

## Setup

To enable Hubzilla, run the appropriate command:

**`make set hubzilla.enable true`**

then run **`make update_one hubzilla`** to finalise the changes

alternatively, you can set the appropriate service settings in `settings/config.yml` to True, and then run **``make update_one hubzilla``**

eg.
```
hubzilla:
  enable: True
```

## Access

It is available at [https://hubzilla.{{ domain }}/](https://hubzilla.{{ domain }}/) or [http://hubzilla.{{ domain }}/](http://hubzilla.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://hubzilla.{{ tor_domain }}/](http://hubzilla.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth, run the appropriate command:

**`make set hubzilla.https_only true`**

**`make set hubzilla.auth true`**

then run **`make update_one hubzilla`** to finalise the changes

alternatively, you can set the appropriate service settings in `settings/config.yml` to True, and then run **``make update_one hubzilla``**

eg.
```
hubzilla:
  https_only: True
  auth: True
```
