# Automated Apple Health Import

HomelabOS supports automatically (kind of) importing of your data from Apple Health.

The non-automatic part is you have to manually create an Export from the Health app on your phone.

Once you upload your export to your [NextCloud](/sofware/nextcloud/) instance, the Apple Health cron task will pick it up within the next hour, and put all the data into [InfluxDB](/software/influxdb). Now you can create nice dashboards in [Grafana](/software/grafana/) to visualize and inspect your Health data.

## Configuring

You need to set the NextCloud username that you want to import Health Data from in your `host_vars/myserver` file. This value defaults to `admin` the default username created at startup by NextCloud.

## Exporting

Make sure you have NextCloud configured on your Apple device. On your Apple device open the `Health` app. Click the `Today` tab, then click the profile icon in the top right of the screen. Now click `Export Health Data`. Once the export completes, save it to NextCloud. Click `Upload` with the default settings. It should save to your `Files` folder with the name `export.zip`.

Now in under an hour you should be able to see your data in Influx via Grafana.

## Debugging

You can always open up [Portainer](/software/portainer/) and view the Logs of the `homelabos_apple_health_influx_1` container to see if things are working or not.

## Access

There is no direct access to this service, you can visualize the data through Grafana.