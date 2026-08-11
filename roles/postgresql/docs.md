# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system.

## Access

PostgreSQL is bound only to localhost on the HomelabOS server, so it is not directly accessible from the network. Use other HomelabOS services on the same Docker network to connect, or SSH to the server and use the `psql` client.

The database password is stored in `settings/passwords/postgresql_password`.

## Connection Details

- **Host:** `postgresql` (within Docker network) or `localhost` (from the server)
- **Port:** `5432`
- **User:** `{{ postgresql.user | default("homelabos") }}`
- **Database:** `{{ postgresql.database | default("homelabos") }}`
- **Password:** See `settings/passwords/postgresql_password`

## Configuration

```
postgresql:
  enable: True
  user: homelabos
  database: homelabos
```

## Security

This service is not exposed via Traefik and is bound to localhost only. To connect from another container, use the Docker network hostname `postgresql`.
