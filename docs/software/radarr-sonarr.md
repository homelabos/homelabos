# Radarr / Sonarr

[Radarr](https://radarr.video/) (Automated movie downloading) and [Sonarr](https://sonarr.tv/) (Automated TV downloading) work esentially the same, so the documentation below applies to both.

## Configuration

To make either Sonarr or Radarr work, you need to configure an
Indexer and a Downlad Client.

The Indexer will be [Jackett](/software/jackett.md). Configure
Jackett first, once that is done, in either Sonarr or Radarr, go
to `Settings` then the `Indexers` tab, and click the Plus button.
Select the `Custom` button undernear `Torznab` and enter
`Jackett` for the name, for the URL enter `http://jackett:9117/api/v2.0/indexers/all/results/torznab/`
and for the API Key, enter the API key that Jackett displays
on it's Dashboard.

Next go to the `Download Client` tab, toggle the `Advanced Settings`
toggle in the top right to `Shown`, then click the Plus button,
select `Transmission`. Enter `transmission` for host,
`9091` for port, and your transmission username and password in
their respective fields. In Sonarr, enter `/tv` under `Directory`
and in Radarr enter `/movies`. This points to the same folders
[Emby](/software/emby.md) reads from, so they should be automatically
detected by Emby if you set this up correctly.

Now if you add some content, either a movie to Radarr or
a TV series to Sonarr, they will automatically be searched
and downloaded according to your settings.

## Access

Sonarr available at [https://sonarr.{{ domain }}/](https://sonarr.{{ domain }}/) or [http://sonarr.{{ domain }}/](http://sonarr.{{ domain }}/)

It is also available via Tor at [http://sonarr.{{ tor_domain }}/](http://sonarr.{{ tor_domain }}/)

Radarr available at [https://radarr.{{ domain }}/](https://radarr.{{ domain }}/) or [http://radarr.{{ domain }}/](http://radarr.{{ domain }}/)

It is also available via Tor at [http://radarr.{{ tor_domain }}/](http://radarr.{{ tor_domain }}/)