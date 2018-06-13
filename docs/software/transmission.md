# Transmission

[Transmission](https://transmissionbt.com/) is available for all your torrenting needs.

HomelabOS uses [docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) to only connect via a VPN. It includes Tinyproxy on port 8888 to provide proxy services over the OpenVPN client connection. To disable the OpenVPN functionality replace the line `image: haugene/transmission-openvpn` with `image: linuxserver/transmission` in `homelabos/templates/docker-compose.yml` then run `make` again from the root directory to update HomelabOS with your new settings. 

## Access

It is available at [http://torrent.{{ domain }}/](http://torrent.{{ domain }}/)