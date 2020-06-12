# Scripts

Some useful scripts which don't necessarily live in any of our other repos.

- `cut-release-candidate.sh` - used to cut a new release candidate of `go-micro` and `micro`, e.g. v2.9.0-rc1. It will create a new release-X.X.X branch (if it doesn't exist) and then create a new release and tag in github.
- `cut-prod-release.sh` - used to cut a new prod release of `go-micro` and `micro`, e.g. v2.9.0. More of an interactive script since we still need to do things manually like merging PRs. It will create a new release and tag of both projects on github and also update go.mod for micro to point to the new go-micro.