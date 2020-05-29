# Dasher

[Dasher](https://github.com/maddox/dasher) provides support for triggering things when you press one of those free Amazon Dash buttons.

Follow [the directions on how to find your Dash button's MAC address](https://github.com/maddox/dasher#find-dash-button). Then plug that MAC address into `roles/homelabos/templates/dasher.config.json`. Edit the URL, headers and body as needed for your use case. The default example shown causes [Home Assistant](/software/homeassistant) to toggle the Living Room lights.

## Access

No direct access, but like all the images you can tail the logs in [Portainer](/software/portainer)
