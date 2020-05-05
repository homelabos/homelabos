# Mayan

[Mayan EDMS](https://mayan-edms.com/) Mayan EDMS is a document management system.

## Access

It is available at [https://{% if mayan.domain %}{{ mayan.domain }}{% else %}{{ mayan.subdomain + "." + domain }}{% endif %}/](https://{% if mayan.domain %}{{ mayan.domain }}{% else %}{{ mayan.subdomain + "." + domain }}{% endif %}/) or [http://{% if mayan.domain %}{{ mayan.domain }}{% else %}{{ mayan.subdomain + "." + domain }}{% endif %}/](http://{% if mayan.domain %}{{ mayan.domain }}{% else %}{{ mayan.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ mayan.subdomain + "." + tor_domain }}/](http://{{ mayan.subdomain + "." + tor_domain }}/)
{% endif %}

## Setting up Watched and Staged folders
1. Change the owner of the watch and staged directories to `www-data`
    > You may or may not need to do this.
    ```
    [client]$ sudo chown www-data path/to/your/watch/dir
    [client]$ sudo chown www-data path/to/your/staged/dir
    ```

2) Go to the Mayan web interface.
    - Go to `System -> settings -> sources`. 
    - Click on `actions -> add new watch folder`
    - Fill out the options, for `Folder Path` type "/watched_files"
    - By default, it will scan for new files every 600 seconds (10 minutes), change that to a lower number if you'd like. 
    - Save
    
    - Click on `actions -> add new stagging folder`
    - fill out the options, for `Folder Path` type "/staged_files"
    - Save