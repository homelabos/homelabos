# NextCloud

[NextCloud](https://nextcloud.com/) is your Dropbox / Google Calendar replacement.

## About

Nextcloud can be a beast to setup. Therefore, HomelabOS does as much as it can to provide intelligent defaults, and common configuration settings out of the box.

Specifically, HomelabOS configures Nextcloud in the following ways:
* Postgres as the default database server, mariadb as an alternative
* Redis for caching
* Nextcloud 22, served by Apache
* Docker is set to run the main Nextcloud container as the same Uid/Gid that mounts your NAS. (or your non-root server-user's UID/GID)
* 'App Store' Access is enabled
* Default Username is pulled from your config/vault yaml file
* Default Password is pulled from your config/vault yaml file
* Mounts/Volumes - these are all configured to persist across container restarts.
  - {{ volumes_root }}/nextcloud/apps - host accessible volume containing self-installed apps.
  - {{ volumes_root }}/nextcloud/config - host accessible volume containing configuration.
    - when necessary, users can directly edit the config.php file - for instance, to fix the login-loop bug with mobile apps.
  - {{ volumes_root }}/nextcloud/themes - host accessible volume containing custom theme files.
  - {{ volumes_root }}/nextcloud/webroot - host accessible volume containing the actuall nextcloud php files, and user-data root folders.
  - {{ storage_dir }}/ - mounted internally as /mnt/homelabos

## Configuration Notes

!!! Warning "Use https_only"
    After you enable Nextcloud, it is recommended to set force https_only on the Nextcloud service to true. However, if you're using the http provisioning system for LetsEncrypt, you'll need to wait to enable https_only until the cert has been generated.

!!! Note "Auto installation takes a few minutes"
    Once make has finished running, it will take a few minutes - depending on your servers' hardware capabilities - to finish setting up Nextcloud. HomelabOS pre-configures:
    * Database
    * Default User & Password - check your config and vault files for details on what these are set to.

!!! Warning "Nextcloud only supports upgrading to the next major version." 
    If the version of nextcloud.version field is not 21-apache, then iteratively update one major version at a time from the version currently running to 22-apache. This can be done by changing the version number explicitly in the nextcloud.version field of settings/config.yml to the next major version and running `make restart_one nextcloud`.

## Post Installation Configuration

Nextcloud, as an application, is *designed* to silo users' data apart from one-another. (this is a good thing). However, this causes issues when you want to allow users to access a common data store - like a NAS. To facilitate this, HomelabOS mounts your hosts' {{storage_dir}} in the container as the /mnt/homelabos folder. Once you've installed and configured Nextcloud, you'll need to take the following steps to make your {{storage_dir}} available to users:

1. Launch settings, and select Apps.
2. Select 'disabled' apps
3. Click the enable button next to 'External Storage Support'
4. _*Logout*_ - Do not skip this step.
5. *Login* and navigate to Settings -> External Storage (*Under Administration*)
6. Add a new External Storage with the following configuration
  - Folder Name: HomelabOS
  - External Storage: Local
  - Authentication: None
  - Configuration: /mnt/homelabos
7. Click the check icon.
8. Profit!

After completing these steps, your Users will see a HomelabOS folder under files. More advanced users can probably re-map the default file locations for pictures etc. to be under the HomelabOS folder.

## Authentik SSO (OpenID Connect)

Nextcloud can authenticate against an Authentik IdP via OpenID Connect using the `user_oidc` app, alongside the normal local login (SSO coexists with local login — local accounts stay available).

To enable it:

1. **Configure the Authentik side (manual prerequisite, outside this role).** In the Authentik admin UI create an OIDC **Provider**:
   - Client Type: Confidential; record the Client ID and Client Secret.
   - Redirect URI (authorization, strict): `https://<your-nextcloud-domain>/apps/user_oidc/code`
   - Add the provider to an **Application** with slug `nextcloud`.
2. **Enable and configure the role** in `settings/config.yml` under `nextcloud:`:
   ```yaml
   nextcloud:
     oidc_enabled: true
     oidc_client_id: <Authentik client id>
     oidc_client_secret: <Authentik client secret>
     oidc_discovery_uri: https://authentik.averneth.com/.well-known/openid-configuration
     # optional, defaults shown:
     # oidc_scope: openid email profile
     # oidc_uid_mapping: preferred_username
   ```
3. Deploy. The role installs/enables `user_oidc` and registers the provider using `occ`.

Notes:
- The role registers the provider with `--unique-uid=0`, so the Nextcloud username equals the Authentik username (`preferred_username`) rather than a `sha256` hash. Do not remove this flag, or `user_oidc` re-enables `unique_uid` (default `1`) and creates hashed usernames.
- The display name comes from the IdP's `name` claim (mapping default `name`). For the SSO user to get a real display name, the Authentik user must have its **name** field set; otherwise Nextcloud falls back to the username.
- **Known issue — avoid fresh SSO login into an existing local account of the same name.** If a local Nextcloud user (e.g. `nick`, Database backend) already exists with the same username as the Authentik user, soft auto-provisioning tries to merge the SSO identity into it and can throw a PostgreSQL `Invalid savepoint` error (``savepoint "doctrine_2" does not exist``) inside `user_oidc`'s `ProvisioningService::provisionUser`, causing a 500 on login. The reliable workaround is to delete the conflicting local account (its data directory can be preserved) and let the SSO login provision a fresh user.
- After setup, the Nextcloud login page shows an SSO button alongside the local form, and you can still log in locally.

## Nextcloud Talk (voice/video calls) & TURN

Nextcloud Talk makes voice/video (WebRTC) calls work across NAT/firewalls by relaying media through a
TURN server (coturn) running as a sidecar container next to Nextcloud. It is disabled by default.

To enable it:

1. **Set the flag** in `settings/config.yml` under `nextcloud:`:
   ```yaml
   nextcloud:
     talk_enabled: true
     # optional: set only if the host is behind a distinct NAT with a stable public IP
     # talk_turn_external_ip: <your-public-ip>
   ```
   Other optional settings with defaults:
   ```yaml
   # talk_turn_version: 4.6.2-r1
   # talk_turn_port: 3478
   # talk_turn_schemes: turn
   # talk_turn_protocols: udp,tcp
   # talk_turn_relay_min: 49160
   # talk_turn_relay_max: 49200
   ```

2. **Mandatory manual step — port forwarding.** On your router/firewall, forward/allow `talk_turn_port`
   (default `3478`) for both UDP and TCP, and the UDP relay range `talk_turn_relay_min`-`talk_turn_relay_max`
   (default `49160`-`49200`), to the HomelabOS host. The role cannot open the router; without this,
   containers and `occ` still configure correctly but calls across distinct NATs will fail.

3. **Deploy.** Run `make config` then `make update_one nextcloud` (or a full `make deploy`). The role
   installs/enables the `spreed` Talk app, renders the coturn config, and registers the STUN/TURN
   servers with Talk via `occ`.

Notes:
- `external-ip` is omitted by default because Homelab clients are typically behind the same NAT.
  Only set `talk_turn_external_ip` if calls fail across distinct NATs and a stable public IP exists;
  setting it pre-emptively can break LAN-internal reachability.
- Non-TLS `turn:` on port 3478 is the default. TLS `turns:` (port 5349) is only needed for clients
  behind firewalls that allow only 443 and would require mounting a TLS cert into coturn — not done
  by default.
- A `static-auth-secret` is generated once and shared between coturn and Talk, so the credentials
  stay stable across redeploys.

### High-performance backend (Signaling server)

!!! Warning "TURN alone does not make Talk 'setup complete'"
    Talk still shows the red banner *"Calls without High-performance backend can cause
    connectivity issues and high load on devices"* until a high-performance backend
    (a **signaling server**) is configured. The coturn **TURN** server only relays
    media (WebRTC) — it is not the high-performance backend, so enabling TURN never
    clears that warning. To remove it you must also enable the signaling server below.

To enable it (a `strukturag/nextcloud-spreed-signaling` container, run standalone with
an internal NATS and reusing the existing coturn for TURN REST credentials):

1. **Set the flag** in `settings/config.yml` under `nextcloud:` alongside
   `talk_enabled: true`:
   ```yaml
   nextcloud:
     talk_enabled: true
     talk_signaling_enabled: true
     # optional, defaults shown:
     # talk_signaling_subdomain: signaling   # served at signaling.<domain>
     # talk_signaling_version: 79d6093
     # talk_signaling_port: 8080
     # talk_signaling_verify: true           # occ talk:signaling:add --verify
   ```
   The signaling server is exposed at `signaling.<domain>` (covered by the existing
   `*.` wildcard DNS / TLS cert, so no extra manual DNS step).

2. **Deploy.** Run `make config` then `make update_one nextcloud` (or a full
   `make deploy`). The role renders the signaling container with shared secrets
   (`nextcloud_signaling_secret`, `…_internal_secret`, `…_hashkey`, `…_blockkey`),
   and registers it with Talk via `occ talk:signaling:add --verify
   https://signaling.<domain> <signaling_secret>`.

3. **Verify.** In Talk admin settings the "High-performance backend" section now shows
   as configured and the warning is gone. From the host:
   `curl https://signaling.<domain>/api/v1/welcome` should return
   `{"nextcloud-spreed-signaling":"Welcome", ...}`.

Notes:
- This deployment omits the Janus WebRTC media gateway (MCU). Signaling is routed
  through the high-performance backend (removing the warning and enabling features
  like typing indicators), while audio/video media still uses peer-to-peer WebRTC
  relayed through coturn — appropriate for a small homelab. Adding a Janus MCU for
  server-side media routing is not part of this role.
- The signaling server and coturn share the same `static-auth-secret`
  (`nextcloud_turn_secret`), so the TURN REST credentials it hands out are accepted
  by the coturn sidecar.
- The signaling router is intentionally exposed **without** auth/authelia middleware;
  the signaling protocol authenticates via the shared secret, and putting SSO in front
  of the WebSocket endpoint would break Talk clients.

Verify after deploying:
- `docker compose -f {{ volumes_root }}/nextcloud/docker-compose.yml ps` shows
  `nextcloud-coturn` and `nextcloud_signaling` `Up`.
- `….exec -T nextcloud php occ talk:stun:list` and `….php occ talk:turn:list` list
  `<your-domain>:<port>` with the expected scheme/protocol.
- `….exec -T nextcloud php occ talk:signaling:list` lists
  `https://signaling.<domain>`.

### Call recording (Talk Recording server)

Server-side call recording records the active speaker during calls to a video file
(`Talk/Recordings`, `.webm`). It uses a `nextcloud/aio-talk-recording` sidecar
(ffmpeg + headless Firefox) that connects to the signaling server via its internal
secret. It requires the High-performance backend above.

To enable it:

```yaml
nextcloud:
  talk_enabled: true
  talk_signaling_enabled: true
  talk_recording_enabled: true
  # optional, defaults shown:
  # talk_recording_version: 20260817_082005   # nextcloud/aio-talk-recording image tag
  # talk_recording_subdomain: recording       # served at recording.<domain>
  # talk_recording_consent: false             # require participant consent before recording
```

Deploy with `make config` then `make update_one nextcloud`. The role:
- starts the recording sidecar and exposes it at `recording.<domain>` (covered by the
  existing `*.` wildcard DNS / TLS cert),
- registers `recording_servers` in the `spreed` app config
  (`{"servers":[{"server":"https://recording.<domain>","verify":true}],"secret":…}`, secret
  generated at `nextcloud_recording_secret`), which activates Talk's `call_recording`,
- sets `recording_consent` (`1` when `talk_recording_consent` is `true`, else `0`).

Verify after deploying:
- `docker compose -f {{ volumes_root }}/nextcloud/docker-compose.yml ps` shows
  `nextcloud_recording` `Up` (healthy).
- `curl https://recording.<domain>/api/v1/welcome` returns `{"version":…}`.
- `….exec -T nextcloud php occ config:app:get spreed recording_servers` returns the
  servers URL + secret.

!!! Note "Live transcription"
    Real-time live captions in calls are provided by the separate `live_transcription`
    ExApp, which additionally requires an AppAPI Deploy Daemon and substantial CPU/RAM
    (~16 GB recommended). It is deliberately not deployed by this role or on the default
    host; only post-call recording (above) is enabled here.

## Access

It is available at [https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/) or [http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nextcloud.subdomain + "." + tor_domain }}/](http://{{ nextcloud.subdomain + "." + tor_domain }}/)
{% endif %}
