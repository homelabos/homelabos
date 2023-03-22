# Release Process

This is the process to cut a new versioned release.

* Cut the Release
  * Make a new GitLab Issue for the release.
  * Start a MR for the Issue.
  * Set the version number of the new release in the files: `VERSION`, `CHANGELOG`, and `install_homelabos.sh`
  * Push up docker image for latest build
    * `docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t nickbusey homelabos:v0.9 . --push`
  * Push up changes, merge MR into master
  * From master tag the release in GitLab

* Clean up the dev branch
  * Revert version to `dev` in the files: `VERSION`, `CHANGELOG`, and `install_homelabos.sh`
