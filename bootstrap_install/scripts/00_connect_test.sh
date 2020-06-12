#!/bin/bash

. config_secrets

echo
echo "# Test connection to HLOS"
echo "#################################################"
$CURL $host_url/
echo
