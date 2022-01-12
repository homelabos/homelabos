use Mix.Config

config :pleroma, Pleroma.Web.Endpoint,
   http: [ ip: {0, 0, 0, 0}, ],
   url: [host: '{% if pleroma.domain %}{{ pleroma.domain }}{% else %}{{ pleroma.subdomain + "." + domain }}{% endif %}', scheme: "https", port: 443],
   secret_key_base: "{{secret_key.stdout}}"

config :pleroma, :instance,
  name: "Pleroma",
  email: "{{admin_email}}",
  limit: 5000,
  registrations_open: true

config :pleroma, :media_proxy,
  enabled: false,
  redirect_on_failure: true,
  base_url: "https://cache.domain.tld"

# Configure your database
config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pleroma",
  password: "{{lookup('password', './settings/passwords/pleroma_db_password chars=ascii_letters')}}",
  database: "pleroma",
  hostname: "pleromadb",
  pool_size: 20
