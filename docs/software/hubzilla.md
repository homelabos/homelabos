# Hubzilla

[Hubzilla](https://framagit.org/hubzilla) is a powerful platform for creating interconnected websites featuring a [decentralized/nomadic identity](https://zotlabs.org/page/hubzilla/hubzilla-project).

## Setup

To enable Hubzilla, run the following command:

**`make set hubzilla.enable true`**

then run **`make update_one hubzilla`** to finalise the changes

alternatively, you can set the appropriate service settings in `settings/config.yml` to True, and then run **``make update_one hubzilla``**

eg.
```
hubzilla:
  enable: True
```
## SMTP/ Mail

Hubzilla makes pretty good use of a mail server. If you don't want to run your own, sign up for a service like [mailgun](https://www.mailgun.com/).

Setting up such a service is beyond the scope of the HomelabOS documentation, however there is plenty of information out there.

Once you have access to a mail server, or a mail service provide Hubzilla with the necessary information.

1. run **`make decrypt`** to decrypt the `vault.yml` file, located in your homelabos `settings` folder.

2. Access that file (you might need superuser/root/administrator permissions) and change the following options to reflect your own credentials

```
# SMTP Settings
smtp:
  host: 
  port: 
  user: 
  pass: 
  from_email: 
  from_name: 
```
3. Then run **`make update_one hubzilla`** to update Hubzilla; HomelabOS will automatically re-encrypt your vault.yml file

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
