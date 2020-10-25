# Upload Source

This document outlines some lacking corners of the runtime, like accessing private code and running code on k8s without
an additional CI/CD step.

While thinking about the runtime it's worth to keep in mind that some behaviour experienced when `micro server` runs on the user's machine
falls into the category of "free lunch", for example
- go.mod replaces to local packages work
- access to private repo GitHub repos might also work because the `micro server` has access to the same envars as the user.

A more useful reference point and though framework is the test suite: since they run on docker container there is a level of isolation.
In fact the test suite is exactly what triggered the "uploading local code to `micro server`" functionality implementation as `micro run .` became utterly broken
once the tests were ran in containers.

We need to also think about both local codes (`micro run .`) and urls (`micro run github.com/micro/examples/helloworld`) when discussing features, as both should work.

## Accessing private code

This document proposes the following solution to the private dependency issue:

- User acquires a [personal access token from GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) and does a `micro config set [key to be decided] [access token]`
- The runtime can then use said token to access source code
  - Default runtime might need to do specific setup steps because every machine is different [This article contains some ideas, although it is docker specific](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)
  - K8s runtime can have prebuilt images which handles all this given the token is passed down to it.*

(*) This takes us to our next point

## Running code in k8s without CI

We have previously explored the concept of [dynamically downloading source code](https://github.com/micro/micro/tree/master/service/runtime/cells) and running it. The same idea could be done for v1 and it would closely match the spirit of the local workflow too: `micro update .` followed by `micro logs -f [name]` to see build output.

With rolling updates and readiness checks this solution should suffice for v1. Of course we can still leave space in the flow for a CI/CD pipeline to happen as many teams will likely have that but that can be outside the scope of v1.

## Uploading code to k8s

This functionality is currently broken as we use the same `github.com/micro/services` for all services and the file upload functionality uses the file system which is obviously a no-no in a distributed setting.

What should happen instead is local code zipped and uploaded should be written to the store and it should be loaded on demand by the container.
