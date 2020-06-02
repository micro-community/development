# Release Process

As we mature as an organisation we need to refine the release process to ensure that we can maintain a high velocity while also keeping code quality and stability high. This applies to both the OSS go-micro as much as any work on m3o or any other product.

The overarching approach should be to ensure that all changes undergo some form of extended testing period. Remember, the blast radius of errors in our code goes far beyond our own organisation so care must be taken.

## go-micro

`go-micro` is generally consumed by users using the go module system which means that users will be pinned to named releases rather than `master` branch. *However* there is still (probably) a large number of folks who just `go get/install` without modules or anything else who will get `master` branch. This means we should follow a process that shields `master` from potentially unstable code.

We generally aim to cut new releases of the `go-micro` project frequently; approx every 2 weeks. 

#### Process
The process should follow the [git-flow](https://nvie.com/posts/a-successful-git-branching-model/) model of branching. 

We will have 2 long lived branches; 
- `master`, which should be stable and production ready
- `develop`, which reflects the latest and greatest feature development

All feature branches will be branched from and merged back to `develop` via the usual PR process. 

New release candidates will be cut from the `develop` branch roughly every 2 weeks. New releases are cut from the `develop` branch as `release-X.X.X`. From this point, only bug fixes should be added to the release branch. 

If all clear after 7 days we will promote the release candidate to full version and cut a new release which means
1. merging the branch to `master`
1. tagging the `master` branch with the new release version `X.X.X`
1. merging the branch to `develop`
1. deleting the release branch


#### Testing
Before a release is given the all clear we must run a full suite of tests. Testing will include being built and run against:
- the current latest versioned release of `micro` 
- all of the example projects in https://github.com/micro/examples

We will also encourage users to start using releaase candidates in their testing CI and testing environments and ask them to report back with any issues. 


### micro

The `micro` project is generally consumed as both tagged releases *and* directly from `master`. Users will `go install` both with and without an explicit release version. So it should follow the same branching and release process as defined for `go-micro` above which protects `master` as much as possible. 

#### Testing
Testing will include 
- running all integration tests in CI 
- running in non prod environment of m3o to shake out any bugs that require longer running

### Versioning
We follow the [semantic versioning](https://semver.org/) approach to release names. 