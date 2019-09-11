# Authelia

[Authelia](https://www.authelia.com) is an open-source full-featured authentication server.

## What is this?

When enabled, Traefik will forward most requests to Authelia for authentication. Once you login to authelia, it will redirect you to the service you requested. For instance, if you navigate to firefly.yourdomain.com, traefik will auto-redirect you to auth.yourname.com. Once you authenticate, it will redirect you back to firefly.yourdomain.com. This centralizes your authentication for all your homelab servcies. Additionally, Authelia is two-factor enabled. You can either register a new device, ie: google authenticator app, or use the Duo.com push notification service.

On the backend, Authelia authenticates your user to it's own OpenLDAP instance. This instance is isolated to Authelia, and is different than the openldap service Homelabos offers.

## Prerequisites

1. Authelia requires a working SMTP server to authenticate new users and register devices.

## Configuration

Homelabos ships with intelligent defaults for Authelia. However, there are some choices you must make. In config.yml, there is an Authelia section. The configuration options are explained below:

### Authelia configuration options

- log_level: defaults to debug, you can set to 'error' as well
- use_username: Defaults to true. if true, your authellia login name is your config.yml's default username: {{default_username}}. If set to false, it defaults to your first and last names: {{ open_ldap.seed.first_name }} {{ open_ldap.seed.last_name }}
- max:
  - retries: this is the maximum number of times someone can _fail_ to authenticate within a given time frame before being locked out. (defaults 5)
  - retries_in_time: this is the time frame that a user has to fail X times in before they're banned. (Defaults to 2min.)
  - retries_ban_time: How long a user is prohibited from logging in after failing X times in Y mintes, per the first two variables. (defaults to 5 minutes) These three combined (as defaulted), means that a user who fails to authenticate 5 times within 2 minutes is banned for 5 minutes.
- default:
  - factor_count: The number of authentication factors required to login. Options are:
    1. bypass - Authelia will not require authentication
    2. one_factor - only a user/pass is required.
    3. two_factor - (_default_) Username/password as well as a second factor is required.
    4. deny - authelia will prevent login and access to the services.
  - cookie_expiration: How long the authentication cookie is good for. (default: 1hr)
  - cookie_inactivity: How long the cookie can sit, without being refreshed (ie: user is active) before expiring. (Defaults to 5min)
  - policy: This is the default policy for any un-named service. This is the policy for everything unless overriten by other service rules.
- users_ou: organization unit defining the 'users' attribute. Defaults to users. Unless you know what you're doing, do not edit.
- groups_ou: organization unit defining the 'groups' attribute. Defaults to groups. Unless you know what you're doing, do not edit.

### Related open_ldap

- open_ldap:
  - organization: the ldap org. _you must specify this_
  - domain: the ldap domain controlled by this openldap instance. Defaults to: {{ domain }}
  - hostname: unless you know what you're doing, this should match your domain. _required_
  - enhanced_debugging: defaults to False. Enables debug level logging.
  - seed:
    - first*name: Your first name. \_required*. Used to seed the ldap database.
    - last*name: Your last name. \_required*. Used to seed the ldap database.

## Access

It is available at [https://auth.{{ domain }}/](https://auth.{{ domain }}/) or [http://auth.{{ domain }}/](http://auth.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://auth.{{ tor_domain }}/](http://auth.{{ tor_domain }}/)
{% endif %}
