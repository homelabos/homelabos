# Release Process

This is the process to cut a new versioned release.

1. Make a new GitLab Issue for the release.
* Start a MR for the Issue.
* Set the VERSION file with the version number of the new release.
* Update CHANGELOG with new version number
* Push up docker image for latest build
  * `docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t nickbusey homelabos:v0.8.6 . --push`
* Push up changes, merge MR into master
* From master tag the release in GitLab
* Check out dev, revert VERSION to `dev`
