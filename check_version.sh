#!/bin/bash

VERSION_CURRENT=$(cat VERSION)
VERSION_LATEST=$(curl -s https://gitlab.com/NickBusey/HomelabOS/raw/master/VERSION)

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

echo -e "Current Version:\x1B[01;94m $VERSION_CURRENT \x1B[0m"
echo -e "Newest Version:\x1B[01;95m $VERSION_LATEST \n\x1B[0m"

if [ ${#VERSION_LATEST} ]; then 
  echo "var is unset"; 
else 
  echo "var is set to '$VERSION_LATEST'"; 
fi

if version_gt $VERSION_LATEST $VERSION_CURRENT; then
   echo -e "You should update to $VERSION_LATEST"
   echo -e "Update at https://gitlab.com/NickBusey/HomelabOS\n"
else
  echo -e "You are up to date!\n"
fi