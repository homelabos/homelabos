#!/bin/bash

. config_secrets

echo
echo "# Run ansible-vault encryption on hlos"
echo "#################################################"
# NOTE: vault password is passed via ANSIBLE_VAULT_PASSWORD_FILE environment variable in the ansible-api container.
n="encrypt-vault#id@hlos"
m="command" # or 'script'/'shell'
a="docker exec ansible-api_ansible-api_1 ansible-vault encrypt /playbooks/settings/vault.yml"
t="$host_ip"
s=`echo -n $n$m$t$key|sha256sum|cut -d' ' -f1`

command_post_data()
{
  cat <<EOF
{
  "n":"$n",
  "m":"$m",
  "a":"$a",
  "t":"$t",
  "s":"$s"
}
EOF
}

echo "$(command_post_data)"
$CURL --data "$(command_post_data)" -H "Content-Type: application/json" -X POST $host_url/command | json_pp
