package templates

var ConfigTemplate = `### REQUIRED ###
# These values are REQUIRED for HomelabOS to work.

# Domain that will be used to point at the server
# Must have a DNS A record of '*.yourserver.com' pointing at your server's IP.
domain: {{"{{"}} domain | default('localhost') {{"}}"}}

# SSH accessible IP address
homelab_ip: {{"{{"}} homelab_ip {{"}}"}}

# SSH Port
homelab_port: {{"{{"}} homelab_port | default('22') {{"}}"}}

# User name used to connect via ssh. Must have passwordless sudo.
homelab_ssh_user: {{"{{"}} homelab_ssh_user {{"}}"}}

# Timezone of the server
common_timezone: {{"{{"}} common_timezone | default('Etc/UTC') {{"}}"}}

# An email that is accessible outside of HomelabOS that you can receive system alerts and notices at.
# Necessary for SSL / LetsEncrypt to work.
admin_email: {{"{{"}} admin_email | default('test@test.com') {{"}}"}}

ansible_port: {{"{{"}} ansible_port | default(22) {{"}}"}}

# Default user name to create as admin with services
default_username: {{"{{"}} default_username {{"}}"}}

# Default storage location for service data, such as configuration data
volumes_root: {{"{{"}} volumes_root | default('/var/homelabos') {{"}}"}}

# Default storage location for media (These are used as local directories or NAS mount points depending on configuration)
storage_dir: {{"{{"}} storage_dir | default('/mnt/nas') {{"}}"}}

# Default Ubuntu release name to follow. Valid examples include: bionic, cosmic, disco
ubuntu_release: {{"{{"}} ubuntu_release | default('focal') {{"}}"}}

# For technical reasons these can't live here.
#ansible_become_password: In vault.yml
#default_password: In vault.yml

# Set this to true if you are deploying to an ARM infrastructure, such as a Raspberry Pi.
arm: {{"{{"}} arm | default('False') {{"}}"}}

# Used by OpenLDAP
ldap_org_name: {{"{{"}} ldap_org_name | default('My LDAP Org') {{"}}"}}

# This configuration dictionary sets various details of your bastion host.
# see the docs for more information about what a bastion host is and how
# the HomelabOS bastion host works.
bastion:
  # should HomelabOS utilize a bastion server?
  enable: {{"{{"}} bastion.enable | default(False) {{"}}"}}
  # Bastion host main ethernet interface name
  interface: {{"{{"}} bastion.interface | default("eth0") {{"}}"}}
  # must provide passwordless sudo
  server_ssh_user: {{"{{"}} bastion.server_ssh_user | default('root') {{"}}"}}
  # Can be an IP or a hostname
  server_address: {{"{{"}} bastion.server_address | default(False) {{"}}"}}
  wireguard:
    bastion_vpn_address: {{"{{"}} bastion.wireguard.bastion_vpn_address | default("10.0.1.1") {{"}}"}}
    homelab_vpn_address: {{"{{"}} bastion.wireguard.homelab_vpn_address | default("10.0.1.2") {{"}}"}}
    netmask: {{"{{"}} bastion.wireguard.netmask | default("/24") {{"}}"}}
    port: {{"{{"}} bastion.wireguard.port | default("51820") {{"}}"}}
    keepalive: {{"{{"}} bastion.wireguard.keepalive | default("25") {{"}}"}}
  ports_to_forward:
    2222: 22
    222: 222
    80: 80
    443: 443
    25: 25
    143: 143
    587: 587
    998: 998
    4190: 4190
    465: 465
    110: 110
    993: 993
    995: 995
  # MIGRATION v0.7
  # Should HomelabOS reset the bastion server IP tables rules?
  # Enable this if you are upgrading a Tinc bastion host
  reset_iptables: {{"{{"}} bastion.reset_iptables | default(False) {{"}}"}}
  # END MIGRATION

{% raw %}
# Minio access keys
minio_access_key: "{{"{{"}} vault.minio_access_key {{"}}"}}"
minio_secret_access_key: "{{"{{"}} vault.minio_secret_access_key {{"}}"}}"

# VPN For Transmission to use for Downloads
openvpn_provider: "{{"{{"}} vault.openvpn_provider {{"}}"}}"
openvpn_username: "{{"{{"}} vault.openvpn_username {{"}}"}}"
openvpn_password: "{{"{{"}} vault.openvpn_password {{"}}"}}"
openvpn_config: "{{"{{"}} vault.openvpn_config {{"}}"}}"

# Cloud Servers
aws:
  secret_key: "{{"{{"}} vault.aws.secret_key {{"}}"}}"
  access_key: "{{"{{"}} vault.aws.access_key {{"}}"}}"
  region: "{{"{{"}} vault.aws.region {{"}}"}}"

do_access_token: "{{"{{"}} vault.do_access_token {{"}}"}}"
do_region: "{{"{{"}} vault.do_region {{"}}"}}"
do_size: "{{"{{"}} vault.do_size {{"}}"}}"

# After claiming your token at https://www.plex.tv/claim/ you will only have four minutes to run make and deploy plexinc
plex_claim: "{{"{{"}} vault.plex_claim {{"}}"}}"

# Mapbox Api keys: Used for OwnPhotos
mapbox_api_key: "{{"{{"}} vault.mapbox_api_key {{"}}"}}"

# Restic S3 Backup Server Information name: Docs: https://homelabos.com/docs/setup/backups/
s3_access_key: "{{"{{"}} vault.s3_access_key {{"}}"}}"
s3_secret_key: "{{"{{"}} vault.s3_secret_key {{"}}"}}"
s3_backup_password: "{{"{{"}} vault.s3_backup_password {{"}}"}}"

# Home Assitant API Key
homeassistant_api_key: "{{"{{"}} vault.homeassistant_api_key {{"}}"}}"

# Xfinity Data Usage Settings
xfinity_user: "{{"{{"}} vault.xfinity_user {{"}}"}}"
xfinity_password: "{{"{{"}} vault.xfinity_password {{"}}"}}"

# SMTP Settings
smtp:
  host: "{{"{{"}} vault.smtp.host {{"}}"}}"
  port: "{{"{{"}} vault.smtp.port {{"}}"}}"
  user: "{{"{{"}} vault.smtp.user {{"}}"}}"
  pass: "{{"{{"}} vault.smtp.pass {{"}}"}}"
  from_email: "{{"{{"}} vault.smtp.from_email {{"}}"}}"
  from_name: "{{"{{"}} vault.smtp.from_name {{"}}"}}"

traefik:
  https_only: "{{"{{"}} vault.traefik.https_only {{"}}"}}"
  domain: "{{"{{"}} vault.traefik.domain {{"}}"}}"
  subdomain: "{{"{{"}} vault.traefik.subdomain {{"}}"}}"
  auth: "{{"{{"}} vault.traefik.auth {{"}}"}}"
  expose_internally: "{{"{{"}} vault.traefik.expose_internally {{"}}"}}"
  expose_externally: "{{"{{"}} vault.traefik.expose_externally {{"}}"}}"
  # Enable sendAnonymousUsage?
  # Reference: https://docs.traefik.io/master/contributing/data-collection/
  send_anonymous_usage: "{{"{{"}} vault.traefik.send_anonymous_usage {{"}}"}}"
  dns_challenge_provider: "{{"{{"}} vault.traefik.dns_challenge_provider {{"}}"}}"
# use key:value pairs here to add additional environment variables to your traefik docker image.
# for instance, if you're using a dns challenge provider place your api keys etc here.
  additional_env_vars:
    # DUMMY_KEY: DUMMY_VALUE
    CF_API_EMAIL: "{{"{{"}} vault.traefik.additional_env_vars.CF_API_EMAIL {{"}}"}}"
    CF_API_KEY: "{{"{{"}} vault.traefik.additional_env_vars.CF_API_KEY {{"}}"}}"
{% endraw %}

# Features
# You can enable/disable different HomelabOS features here by changing False to True and vice versa.

# TOR Access
# This enables access with a TOR hidden service. Both HTTP and SSL. https://homelabos.com/docs/setup/tor/
enable_tor: {{"{{"}} enable_tor | default(False) {{"}}"}}

# HomelabOS Documentation, only shows docs for services you have enabled
docs:
  enable: {{"{{"}} docs.enable | default(enable_docs, None) | default(True) {{"}}"}}
  https_only: {{"{{"}} docs.https_only | default(False) {{"}}"}}
  auth: {{"{{"}} docs.auth | default(False) {{"}}"}}
  domain: {{"{{"}} docs.domain | default(False) {{"}}"}}
  subdomain: {{"{{"}} docs.subdomain | default("docs") {{"}}"}}
  version: {{"{{"}}docs.version | default("latest") {{"}}"}}

# Services

{{ range $service := . }}{{ $service.Name }}:
  enable: {{"{{"}} {{ $service.Name }}.enable | default(enable_{{ $service.Name }}, None) | default(False) {{"}}"}}
  https_only: {{"{{"}} {{ $service.Name }}.https_only | default(False) {{"}}"}}
  auth: {{"{{"}} {{ $service.Name }}.auth | default(False) {{"}}"}}
  domain: {{"{{"}} {{ $service.Name }}.domain | default(False) {{"}}"}}
  subdomain: {{"{{"}} {{ $service.Name }}.subdomain | default("{{ $service.Name }}") {{"}}"}}
  version: {{"{{"}} {{ $service.Name }}.version | default("{{ $service.Version }}") {{"}}"}}
{{ $service.AdditionalConfigs }}
{{ end }}

### OPTIONAL ### These valuse are OPTIONAL and enable extra HomelabOS functionality.

# NAS Config (Docs: https://homelabos.com/docs/setup/installation/#nas-network-attached-storage-configuration)
nas_enable: {{"{{"}} nas_enable | default(False) {{"}}"}}
nas_host: {{"{{"}} nas_host | default() {{"}}"}}
nas_mount_type: {{"{{"}} nas_mount_type | default() {{"}}"}}
nas_share_path: {{"{{"}} nas_share_path | default() {{"}}"}}
nas_user: {{"{{"}} nas_user | default(default_username) {{"}}"}}
nas_pass: {{"{{"}} nas_pass | default() {{"}}"}}
nas_workgroup: {{"{{"}} nas_workgroup | default() {{"}}"}}

# Example: 0 4 * * *
# Backup every day at 4:00 AM
s3_backup_cron: {{"{{"}} s3_backup_cron | default("0 4 * * *") {{"}}"}}
s3_path: {{"{{"}} s3_path | default() {{"}}"}}

apple_health_nextcloud_username: {{"{{"}} apple_health_nextcloud_username | default()  {{"}}"}}
`