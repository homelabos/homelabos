1. Make a new GitLab Issue for the release.
* Start a MR for the Issue.
* Set the VERSION file with the version number of the new release.
* Update CHANGELOG with new version number
* Push up docker image for latest build
* Push up changes, merge MR into master
* From master tag the release in GitLab
* Check out dev, revert VERSION to `dev`
