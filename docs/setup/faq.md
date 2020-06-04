# Troubleshooting / FAQ

This is the Frequently Asked Questions section.

Use the page table of contents to navigate it quickly. Also the search in these docs is instant and easy.

## `make` command throws a docker related error

* Make sure HomelabOS successfully installed docker on the server. If its not installed, try installing it manually.
```
[server]$ docker run hello-world
```
* Make sure you are running the latest docker and docker compose on both your client and server. The Docker version installed via `apt` can be old. Recommended install directions are [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Check HomelabOS status on the server and make sure it is loaded and active.
```
[server]$ systemctl status homelabos
```
* Make sure the admin user specified during `make config` is created.
```
[server]$ compgen -u
```
* If the user isn't listed, run the following commands to make one and add it to the sudo and docker groups.
```
[server]$ sudo adduser <username>
[server]$ sudo usermod -aG sudo <username>
[server]$ sudo usermod -aG docker <username>
```

## I have pointed my domain at my IP but hitting the domain returns nothing

* If you ping your `{{ domain }}`, do you get the IP you expect?
    * If not you have [DNS issues](/docs/setup/installation/#dns-settings). Get those resolved before moving on.
* If you ping `subdomain.{{ domain }}`, do you get the IP you expect?
    * If not you have [DNS issues](/docs/setup/installation/#dns-settings). You probably don't have a wildcard set up.
* Does the IP you expect actually lead to port 80 on your server?
    * You may need to set up port forwarding on your router, unblock some ports on your modem, or contact your ISP to see if they are being blocked. If these aren't an option for you, try the [bastion host](/setup/bastion) set up.
* Does the domain you're trying to hit match what is listed in the Traefik dashboard?
    * If you don't see your domain under the 'HTTP' section in Traefik, then you have something configured wrong.
* Are your services running? Check `docker ps` and `systemctl status SERVICENAME`
    * E.g. `systemctl status organizr` on the server.
* Are your services listed in the Traefik dashboard? Hit http://{{ homelab_ip }}:8181/

If you can hit DOMAIN.com and get SERVER_IP where port 80 and 443 are forwarded and DOMAIN.com is listed in Traefik as the Organizr endpoint, and you STILL can't load the page, ask in [chat](https://homelabos.zulipchat.com/) or open an issue on [GitLab](https://gitlab.com/NickBusey/HomelabOS/-/issues).

## I get a 404

If you're up and running, but getting a 404, load [http://YOURSERVERIP:8181/]. This is the Traefik dashboard.

Each service under the `Http` page has a section. The hostname inside `Host()` in the rule column is the hostname that Traefik is listening to for that particular service. You need to be able to `ping` that hostname from your computer, and you should get back the IP address of your server. Once that is the case, accessing the hostname in a browser should load the respective service.

Traefik serves based on domain names, not IP addresses. It has to know what service you want to return. You need to be able to hit {{ domain }} or servicename.{{ domain }} in order for Traefik to serve the correct service.

## No Traefik Dashboard

If you can't even access the dashboard at {{ homelab_ip }}:8181, check the status of the HomelabOS service.
```
[server]$ systemctl status homelabos
```
This should give you some insight into what the issue is. Also you should be able to run
```
[server]$ docker ps | grep traefik
```
and get an output like:
```
8f00f6b3cdb6        traefik                        "/traefik"               13 hours ago        Up 13 hours                     0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:8181->8080/tcp           homelabos_traefik_1
```

## Services Not Appearing in Traefik, Bad Gateway, or Services Restarting

If you don't see the services listed in the Traefik dash, or if Traefik returns a page that just says `Bad Gateway`, that usually means DNS and everything is correct, but the service itself is having problems. SSH into the server and run `systemctl status SERVICE_NAME` replacing SERVICE_NAME with the service you are interested in. This should show you any relevant Docker logs. If you want more detail from a specific container, you can tail the logs of thatcontainer. Find the containar name with `docker ps | grep SERVICENAME` then access the logs with `docker logs -f --tail 500 CONTAINERNAME`.

## SSL Not working

Traefik generates SSL certs via LetsEncrypt, and LetsEncrypt has rate limiting. So it may take several days before all of your services get valid SSL certs generated for them. You can tail the logs of the traefik container to see the status of it's generation.

## I can't find certain config values like Authelia

Check your `config/vault.yml` file. If it's encrypted just run `make decrypt`

You also don't need to edit the `config/` files directly at all, or worry about where the config values are. Just use `make set` and `make get` and it will access the variable correctly regardless of what config file it lives in.

## I get `exec user process caused 'exec format error'`

You are trying to run AMD code on ARM infrastructure. Make sure you have set `arm` to True in your config file.

## How do I tell if a service is enabled?

On your server run `systemctl status servicename` or `sudo systemctl status servicename` if you are not logged in as root.

## I get `Unit servicename.service could not be found.`

The service was not deployed. Check your `settings/` files. Make sure `servicename.enable` is set to true.

## Is it OK to manually edit my `settings/` files?

Yes.

## If I don't have a domain, what do I enter for the domain field?

Make something up. Something like `myhomelab.local` is fine. HomelabOS will generate a file on the server `/var/homelabos/homelabos_hosts`. You can use this file to add to your computer's hosts override file (`/etc/hosts` on *nix based OSs), or to map on your router or DNS server as DNS overrides. HomelabOS generates one line o `SERVER_IP SERVICE_NAME.DOMAIN_NAME SERVICENAME` for each service. So if you used the example fake domain given above, and you enabled [Jellyfin](../software/jellyfin.md), you can access it at `jellyfin.myhomelab.local` once you have your DNS overrides set up.

## Can I use a 32 bit OS?

No.

Docker requires 64 bit. Nothing we can do about that, sorry.
