#!/bin/bash

. config_secrets

# Use this one to just update a single service:
#  @./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(FILTER_THIS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
echo
echo "# HLOS deploy base system (instead of using Makefile)"
echo "#####################################################"
hlos="/playbooks"
n="deploy_host_deps#id@hlos"
h="$host_ip"
f="playbook.homelabos_api.yml"
e="$hlos/settings/config.yml"

playbook_post_data()
{
  s=`echo -n $n$h$f$key|sha256sum|cut -d' ' -f1`
  cat <<EOF
{
  "n":"$n",
  "h":"$h",
  "f":"$f",
  "s":"$s",
  "e":"$e",
  "c_cmd1":"-e \"@$hlos/settings/vault.yml\"",
  "c_cmd2":"--tags deploy_host_deps"
}
EOF
}

echo "$(playbook_post_data)"
$CURL --data "$(playbook_post_data)" -H "Content-Type: application/json" -X POST $host_url/playbook | json_pp
