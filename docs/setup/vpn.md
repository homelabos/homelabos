# VPN Setup

This bit is not quite automated yet, so you'll have to run the following commands on the server by hand.

```
# Create config
docker run -v {{ volumes_root }}/openvpn:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://vpn.{{ domain }}:1194

# Create PKI
docker run -v {{ volumes_root }}/openvpn:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

# Create a client (repeat as needed)
docker run -v {{ volumes_root }}/openvpn:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full USERNAME nopass

# Get client connection file (repeat as needed)
docker run -v {{ volumes_root }}/openvpn:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient USERNAME > USERNAME.ovpn
```

Once you run those 4 lines you will have a .ovpn file for each user. Simply copy them off of the server to your machine, and distribute as needed.