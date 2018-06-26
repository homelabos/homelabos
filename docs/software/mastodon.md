# Mastodon

You have to manually configure [Mastodon](https://joinmastodon.org/).

SSH in to your HomelabOS machine and stop the HomelabOS services `systemctl stop homelabos`

Now run the following command `cd /var/homelabos/docker && docker-compose run --rm mastodon_web bundle exec rake mastodon:setup`

Follow the onscreen directions.

Once that is done, start HomelabOS again with `systemctl start homelabos`

## Acces

You can access Mastodon at [https://mastodon.{{ domain }}/](https://mastodon.{{ domain }}/) or [http://mastodon.{{ domain }}/](http://mastodon.{{ domain }}/)

It is not available via Tor as it requires as SSL connection to load.