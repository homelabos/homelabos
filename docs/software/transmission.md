# Transmission

[Transmission](https://transmissionbt.com/) is available for all your torrenting needs.

HomelabOS uses [docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) to only connect va a VPN. To disable this functionality replace the line `image: haugene/transmission-openvpn` with `image: linuxserver/transmission` in `homelabos/templates/docker-compose.yml` then run `make` again from the root directory to update HomelabOS with your new settings. 

## Access

It is available at [http://torrent.{{ domain }}/](http://torrent.{{ domain }}/)