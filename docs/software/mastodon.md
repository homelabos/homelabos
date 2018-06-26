# Mastodon

You have to manually configure Mastodon.

SSH in to your HomelabOS machine and stop the HomelabOS services `systemctl stop homelabos`

Now run the following command `cd /var/homelabos/docker && docker-compose run --rm mastodon_web bundle exec rake mastodon:setup`

Follow the onscreen directions.

Once that is done, start HomelabOS again with `systemctl start homelabos`

## Accoss

You can access Mastodon at [https://mastodon.{{ domain }}/](https://mastodon.{{ domain }}/) or [http://mastodon.{{ domain }}/](http://mastodon.{{ domain }}/)

It is also available via Tor at [http://mastodon.{{ tor_domain }}/](http://mastodon.{{ tor_domain }}/)