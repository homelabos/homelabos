echo "Old setting value: "
docker run -it -v ${PWD}:/workdir mikefarah/yq yq r settings/config.yml ${SETTING}
docker run -it -v ${PWD}:/workdir mikefarah/yq yq w -i settings/config.yml ${SETTING}
echo "New setting value: "
docker run -it -v ${PWD}:/workdir mikefarah/yq yq r settings/config.yml ${SETTING}