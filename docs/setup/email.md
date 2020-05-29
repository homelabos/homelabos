# SMTP

In order for your applications to be able to send out emails, you
need an SMTP server. A nice free one is [Mailgun](http://mailgun.com/).

Create an account, and follow their steps to register your domain.

Once that is completed, you can plug the settings they provide into
your `settings/vault.yml` file.
To do this:

1. run the **`make decrypt`** command
2. find and edit the `vault.yml` file
    > NOTE: editing this file will require superuser/ root permissions
3. Set the following settings to what you have been provided

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
4. Save, and run **`make`** again; to re-encrypt the `vault.yml` file


# Mail Server

To have the mailu stack use this SMTP server to send rather
than trying to send mail out directly itself, locate the
`settings/config.yml` file and set:

```
mailu:
  forward_to_smtp: False
```
to ...

```
mailu:
  forward_to_smtp: True
```
