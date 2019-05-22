# Mail Server

[Documentation](https://github.com/hardware/mailserver/)

# SMTP

In order for your applications to be able to send out emails, you
need an SMTP server. A nice free one is [Mailgun](http://mailgun.com/).

Create an account, and follow their steps to register your domain.

Once that is completed, you can plug the settings they provide into
your `settings/config.yml` file. To have the `mailserver` stack use
this SMTP server to send rather than trying to send mail out directly
itself, set:

```
mailserver:
  forward_to_smtp: True
```

in your `settings/config.yml`.