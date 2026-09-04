# Outline

[Outline](https://www.getoutline.com/) is a fast, collaborative knowledge base
and wiki with a beautiful editor, real-time collaboration, nested collections,
and granular permissions. This role deploys the community edition
(`outlinewiki/outline`) with PostgreSQL and Redis, using local file storage
(no S3 required).

## Important: external authentication is required

Outline has **no built-in username/password accounts**. You must configure an
authentication provider before anyone can log in. This role exposes Outline's
generic OIDC support, which works with any OIDC-capable identity provider —
including the HomelabOS Authentik service. If your identity provider is down,
logins will fail until it returns (existing sessions keep working).

## Configuration

```yaml
outline:
  enable: true
  oidc_enabled: true
  oidc_client_id: <client id from your identity provider>
  oidc_client_secret: <client secret>
  oidc_auth_uri: https://authentik.{{ domain }}/application/o/authorize/
  oidc_token_uri: https://authentik.{{ domain }}/application/o/token/
  oidc_userinfo_uri: https://authentik.{{ domain }}/application/o/userinfo/
  oidc_logout_uri: https://authentik.{{ domain }}/application/o/outline/end-session/
  oidc_display_name: Authentik
```

Optional settings and their defaults:

```yaml
outline:
  db_version: 16-alpine        # postgres image tag
  redis_version: 7-alpine      # redis image tag
  force_https: True            # set False if you terminate TLS elsewhere and hit redirect loops
  upload_max_size: 262144000   # max upload size in bytes (250MB)
  default_language: en_US
  oidc_username_claim: preferred_username
  oidc_scopes: openid profile email
  smtp_enabled: False          # set True to send invite/notification emails via the shared vault SMTP settings
```

## Setting up with Authentik (worked example)

1. In Authentik, create an **OAuth2/OpenID Provider**:
   - Redirect URI: `https://outline.yourdomain.com/auth/oidc.callback`
   - Subject mode: **Based on the User's username**
   - Signing key: any RS256 key
2. Create an **Application** (slug `outline`) bound to that provider.
3. Copy the client ID and secret into your `settings/config.yml` under
   `outline:` as shown above (store secrets in your vault).
4. Deploy: `make update_one outline`
5. The first user to sign in becomes the workspace admin.

Any other OIDC provider (Keycloak, Pocket ID, Authelia with OIDC, etc.) works
the same way — fill in the provider's authorize/token/userinfo endpoints.

## Storage

Documents live in PostgreSQL; file attachments and images are stored on local
disk at `{{ volumes_root }}/outline/data` (`FILE_STORAGE=local`). S3-compatible
storage is not required.

## Notes

- The Outline container runs its own database migrations on startup; upgrades
  are a matter of bumping `outline.version` and redeploying.
- Outline sends security headers that forbid embedding in iframes from other
  origins. If you use a dashboard that iframes services (e.g. Organizr), open
  Outline in a new window/tab instead.
