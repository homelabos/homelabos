# Decrypt vault
make decrypt

echo "Finding key: $1" 
echo "New setting: $2"
FILE=settings/config.yml
sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r $FILE $1 $2 || FILE=settings/vault.yml

echo "Found value in file: $FILE"

echo "Old setting value: "
sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r $FILE $1 $2
sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq w -i $FILE $1 $2
echo "New setting value: "
sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r $FILE $1 $2

# Re-encrypt vault
make encrypt