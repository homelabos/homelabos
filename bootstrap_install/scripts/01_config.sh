#!/bin/bash

. config_secrets

echo
echo "# HLOS run config"
echo "#################################################"
n="config#id@hlos"
h="$host_ip"
f="playbook.config.yml"

#  "v_ansible_become_password":"$v_ansible_become_password",

playbook_post_data()
{
  s=`echo -n $n$h$f$key|sha256sum|cut -d' ' -f1`
  cat <<EOF
{
  "n":"$n",
  "h":"$h",
  "f":"$f",
  "s":"$s",
  "v_homelab_ip":"$v_homelab_ip",
  "v_homelab_ssh_user":"$v_homelab_ssh_user",
  "v_ansible_become_password":"",
  "v_default_username":"$v_default_username",
  "v_default_password":"$v_default_password",
  "v_domain":"$v_domain",
  "v_admin_email":"$v_admin_email",
  "v_volumes_root":"$v_volumes_root",
  "v_common_timezone":"$v_common_timezone"
}
EOF
}

echo "$(playbook_post_data)"
$CURL --data "$(playbook_post_data)" -H "Content-Type: application/json" -X POST $host_url/playbook | json_pp
