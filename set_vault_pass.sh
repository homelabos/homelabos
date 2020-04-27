#!/bin/bash

read -p "Enter a strong password for your ansible vault: "

echo "$REPLY" > ~/.homelabos_vault_pass