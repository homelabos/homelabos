# Maileserver

[Mailserver](https://github.com/hardware/mailserver#dns-setup) is an open source mail server.

## Configuration

This requires some manual setup unfortunately.

Drive your web browser to `http://postfixadmin.{{ domain }}/setup.php`.  Loading this page performs the
needed database migrations for `postfix` to operate.  Use the form to generate an password used to
configure the admin user.

You will need to capture the hash noted.  Shell into your instance and update
`/var/homelabos/mailserver/mail/postfix` and edit `config.inc.php`.  Update `$CONF['setup_password']`
with the hash.  Also update `$CONF['configured']` to `true`.  Now restart using homelabos
using `make restart mailserver`.

Now create yourself an admin user and use it to configure `postfix` for your use.

### DNS Records

In order to be able to send email from this service you have to set some specific DNS records.  Without these
the big email players (gmail etc) will reject email from you because you look very much like a spambot.

#### A Record

**`mail.{{ domain }}`**
```
instance_ip4
```

#### MX Record

**`{{ domain }}`**
```
mail.{{ domain }}
```

#### TXT Records

**`_dmarc.{{ domain }}`**
```
v=DMARC1; p=none; rua=mailto:postmaster@{{ domain }}; ruf=mailto:postmaster@{{ domain }}; sp=none; ri=86400
```

**`mail._domainkey.{{ domain }}`**
```
v=DKIM1; k=rsa; p=some_big_long_hash
```

**`{{ domain }}`**
```
v=spf1 mx a:instance_ip4 ~all
```

##### DKIM Hash

On install `mailserver` creates the details for the `_domainkey` DNS record.  On the instance in
`/var/homelabos/mailserver/mail/dkim/{{ domain }}` there are two files.  The `public.key` file contains the details needed for the DNS record.

##### Digital Ocean PTR

A reverse DNS lookup is often needed for sending email to be processed.  Digital Ocean's DNS system does
not directly provide for creating a PTR record in their networking UI.  You can however, easily create
this DNS entry, simply name your droplet as `{{ domain }}`.  Digital Ocean will then create the reverse
lookup you need.


[This doc](https://github.com/hardware/mailserver#dns-records-and-reverse-ptr) includes more details.

## Access

Postfix admin is available at [https://postfixadmin.{{ domain }}/](https://postfixadmin.{{ domain }}/) or
[http://postfixadmin.{{ domain }}/](http://postfixadmin.{{ domain }}/).

`rspamd` is available at [https://mail.{{ domain }}/](https://mail.{{ domain }}/) or
[http://mail.{{ domain }}/](http://mail.{{ domain }}/).

{% if enable_tor %}
The services are also available via Tor at

* [http://postfixadmin.{{ tor_domain }}/](http://postfixadmin.{{ tor_domain }}/)
* [http://mail.{{ tor_domain }}/](http://mail.{{ tor_domain }}/)
{% endif %}

