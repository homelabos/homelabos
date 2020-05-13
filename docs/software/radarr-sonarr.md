# Radarr / Sonarr

[Radarr](https://radarr.video/) (Automated movie downloading) and [Sonarr](https://sonarr.tv/) (Automated TV downloading) work esentially the same, so the documentation below applies to both.

## Configuration

To make either Sonarr or Radarr work, you need to configure an
Indexer and a Downlad Client.

### Indexer: Jackett

The Download Client will be [Jackett](/software/jackett.md), you should make sure 
that you have it installed and configured to follow these instructions.
Then, in Sonarr (resp. Radarr), go
to `Settings` then the `Indexers` tab, and click the Plus button.
Select the `Custom` button undernear `Torznab` and enter
`Jackett` for the name, for the URL enter `http://jackett:9117/api/v2.0/indexers/all/results/torznab/`
and for the API Key, enter the API key that Jackett displays
on its Dashboard.

### Download client: Transmission

The Download Client will be [Transmission](/software/transmission.md), you should make sure 
that you have it installed and configured to follow these instructions.
Then, in Sonarr (resp. Radarr), go
to the `Download Client` tab, toggle the `Advanced Settings`
toggle in the top right to `Shown`, then click the Plus button,
select `Transmission`. In the form that popped up, enter `transmission` for host,
`9091` for port, and your transmission username and password in
their respective fields.
Indicate the following value for the `Directory` field:

* In Sonarr, enter `/data/complete/tv`
* In Radarr, enter `/data/complete/movies`

Click `Save` to close the modal window. Back in the `Advanced settings` screen,
add a "**Remote Path Mappings**" with the following values:
* Host: `transmission`
* Local Path:  `/downloads`
* (Radarr) Remote Path: `/data/complete/movies`
* (Sonarr) Remote Path: `/data/complete/tv`

## Usage

We recommend that you make sure you point Radarr (resp. Sonarr)
to `/movies` (resp. `/tv`) when you add a movie (resp. TV show).


Now if you add some content, either a movie to Radarr or
a TV series to Sonarr, they will automatically be searched
and downloaded according to your settings.

> **Note**: These configuration steps MUST be followed
> for **both** Sonarr and Radarr. If you use both of them, make sure
> to apply the above in both software.

## Access

Sonarr available at [https://{% if sonarr.domain %}{{ sonarr.domain }}{% else %}{{ sonarr.subdomain + "." + domain }}{% endif %}/](https://{% if sonarr.domain %}{{ sonarr.domain }}{% else %}{{ sonarr.subdomain + "." + domain }}{% endif %}/) or [http://{% if sonarr.domain %}{{ sonarr.domain }}{% else %}{{ sonarr.subdomain + "." + domain }}{% endif %}/](http://{% if sonarr.domain %}{{ sonarr.domain }}{% else %}{{ sonarr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ sonarr.subdomain + "." + tor_domain }}/](http://{{ sonarr.subdomain + "." + tor_domain }}/)
{% endif %}

Radarr available at [https://{% if radarr.domain %}{{ radarr.domain }}{% else %}{{ radarr.subdomain + "." + domain }}{% endif %}/](https://{% if radarr.domain %}{{ radarr.domain }}{% else %}{{ radarr.subdomain + "." + domain }}{% endif %}/) or [http://{% if radarr.domain %}{{ radarr.domain }}{% else %}{{ radarr.subdomain + "." + domain }}{% endif %}/](http://{% if radarr.domain %}{{ radarr.domain }}{% else %}{{ radarr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ radarr.subdomain + "." + tor_domain }}/](http://{{ radarr.subdomain + "." + tor_domain }}/)
{% endif %}
