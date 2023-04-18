# Release Process

This is the process to cut a new versioned release.

* Cut the Release
  * Make a new GitLab Issue for the release targeting the `master` branch.
  * Start a MR for the Issue.
  * Set the version number of the new release in the files: `install_homelabos.sh`, `VERSION` and `CHANGELOG`
  * Push up docker image for latest build
    * Enable buildx on Ubuntu
```
wget https://github.com/docker/buildx/releases/download/v0.10.4/buildx-v0.10.4.linux-amd64
mkdir -p ~/.docker/cli-plugins/
mv /var/homelabos/install/buildx-v0.10.4.linux-amd64 ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
docker buildx create --use
docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t nickbusey/homelabos:v0.9.2.1 . --push
```
  * Push up changes, merge MR into master
  * From `master` tag the release in GitLab. Add that version's `CHANGELOG` section to the `Message` of the tag.

* Clean up the dev branch
  * Revert version to `dev` in the files: `install_homelabos.sh`, `VERSION` and `CHANGELOG`
