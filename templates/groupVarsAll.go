package templates

var GroupVarsAll = `---
services:
{{ range $service := . }}  {{ $service.Name }}: 
{{ end }}

{{ range $service := . }}{{ $service.Name }}: 
{{ end }}

enable_tinc: false
vpn_ip: 10.0.0.1
netname: homelabos
vpn_interface: tun0
vpn_netmask: 255.255.0.0
vpn_subnet_cidr_netmask: 32
smtp:
traefik:
  additional_env_vars:
bastion:
  wireguard:
  enable: false
open_ldap:
  seed:
`