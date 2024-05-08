# v2

Getting miniflux working first as an example, then will migrate the rest of the services.

Install k9s
Remove traefik install
Install longhorn
    kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.0/deploy/longhorn.yaml
Install kompose
```
curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
```

Upgrade function
    Add actual port definition based on port from service.yml
        Use yq
    Auto delete unneeded manifests
        homelabos_traefik-networkpolicy.yaml
        {{ service_item }}-networkpolicy.yaml
    Add subPath to the PVC
    Replace all _ with -
    Add "sleep" command to DB deployment
    Copy old data in to DB pod
    Remove "sleep" command from DB deployment
    Create ingress

# v1.1 Nice to haves
Re-enable mitogen.
Automount of volumes
ZFS Cluster
Clean up backup/restore flow
Remove tasks/main.yml if unneeded
