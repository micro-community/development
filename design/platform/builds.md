Compile at runtime
==================

Requirements
------------
* Users tell Micro to deploy code from a specific repo and commit
* The Micro platfrom compiles their code
* The Micro platform deploys their code
* All of this happens without blowing the user's resource allocation budgets

Proposal
--------
* Introduce a pluggable `Builder` interface:
    - Move the current "deploy a container with a `go run` command" method to a default "OnTheFly" implementation
    - Create a new optional "PreBuild" implementation which passes the request on to a Build service
    - `Build()` method returns a container image and arguments (this would work fine for both of the implementations)
* Host our own pre-made base image which we will run all of the prebuilt Go binaries in, and host it in a local (regional) ScaleWay registry
* Introduce a Build service:
    - Makes sure that each customer has a Docker registry (hosted by Scaleway)
        - Although we probably _could_ stuff everything into one registry I think we should make use of security boundaries wherever we can
    - Builds a container in a two-phase Dockerfile:
        1) Compile a Go binary in a GoLang alpine container
        2) Build a service container in a lightweight Alpine base image (SSL etc)
    - Tags and pushes the image to the customer's Docker registry:
        - Image tag is customer.registry/service:<servicename> (this allows us to store one version of each service in one registry)
* Runtime just calls Build() on whatever the configured builder interface is, and uses the response to come up with the deployment parameters

Questions
---------
* Can this be done with synchronous calls? Building a Go binary, stuffing it into a pre-made base image, then pushing to a local repo shouldn't take too long
