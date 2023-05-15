# Plex Media Server

[Plex](https://plex.tv/) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/](https://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/) or [http://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/](http://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ plex.subdomain + "." + tor_domain }}/](http://{{ plex.subdomain + "." + tor_domain }}/)
{% endif %}


## Configuration

You need to link this new Plex server installation to your Plex.tv account - you can do this before you enable and deploy the service, or afterwards. (If you do not do these steps before installation, then after installation, if you go to the above web address for your Plex installation, you will either be forwarded to the app.plex.tv login screen or be met with a "Not Authorized You do not have access to this server" message from the plex web app.)

Thanks to Zachary Stewart and others in [this support thread for instructions](https://homelabos.zulipchat.com/#narrow/stream/196292-support/topic/Plex.20Claim.20Token/near/195352551):

1. run `cd /var/homelabos/install` (or wherever you installed HomeLabOS) and then run `make decrypt` to convert your vault file to plain text. 

2. In a web browser go to [https://www.plex.tv/claim](https://www.plex.tv/claim) to get a claim code. (This will ask you to login to your Plex.tv account, if you are not already)

3. Edit your vault file by running `sudo nano settings/vault.yml` and look for the line `plex_claim: CHANGE_TO_GIVEN_TOKEN` - replace this with the plex claim code.

4. Use one of the below methods to get Plex to run with the claim code: 
    - If you have not yet installed Plex, this is the point where you should configure any NAS/storage settings or plex specific docker overrides you may need, and then run `make set plex.enable true` and then `make deploy`

    - If you already installed/deployed Plex, you only need to run `make update_one plex`

5. Now when you go to the address of your Plex web app, you should be met with a configuration screen - something like 'How Plex Works' etc. On the following pages it will prompt you to add directories to your Media Libraries.
