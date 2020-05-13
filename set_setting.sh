#!/bin/bash
# Decrypt vault
make decrypt

echo "Finding key: $1" 
echo "New setting: $2"

# Try to figure out where key is defined
FILE=settings/config.yml
SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
if [ -z ${SETTING_VALUE} ]; then
    FILE=settings/vault.yml
    SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
    if [ -z ${SETTING_VALUE} ]; then
        echo "Key does not exist in config.yml nor vault.yml."
        # Re-encrypt vault
        make encrypt
        exit 1
    fi
fi

echo "Found value in file: $FILE"

echo "Old setting value: " ${SETTING_VALUE}
# Setting the new value
sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq w -i "$FILE" "$1" "$2"
NEW_SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
echo "New setting value: " ${NEW_SETTING_VALUE}

# Re-encrypt vault
make encrypt