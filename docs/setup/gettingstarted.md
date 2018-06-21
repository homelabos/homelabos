# Getting Started

Alright once you are all setup and ready to go you should be able to load Organizr at [http://{{ domain }}/](http://{{ domain }}/).

If you see `{ domain }` in the link above, you are either viewing these docs on the hosted GitLab pages and not actually through HomelabOS, or something is configured incorrectly.

## Using Organizr

You can click the `Settings` link, then `Edit Tabs` to be able to add links to all the various HomelabOS services.

In the very near future, HomelabOS will provision these tab links for you automatically.

The URLs for all the services can be found in their individual documentation section.

## HTTPS via LetsEncrypt

HomelabOS will use Traefik's built in LetsEncrypt integration to automatically generate SSL certificates for your various services. If initially some of the certificates don't appear valid, you have likely run into [LetsEncrypt rate limits](https://letsencrypt.org/docs/rate-limits/). Unfortunately the only fix we have for that right now is 'wait a week and try again'.