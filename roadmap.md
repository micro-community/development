# Roadmap

We're tracking and continually evolving the high level roadmap

## Q2 2019

- **MVP** {Platform, Services}
  * Bootstrap Micro OSS in the cloud aka Micro as a service
  * Dogfood by writing services or a complete end-to-end service
  * Consolidate learnings into roadmap and bug-feature list
  * Introduce invite-only service to community at end of quarter

Our Q2 (end of July) goal is to deliver the MVP of the platform. We're taking the open source micro toolkit 
and running it as a service in the cloud. The end state should be a runtime which offers an API, web dashboard, 
CLI, slack bot and service proxy all hosted so that developers don't have to host it themselves. We'll 
provide interconnectivity via a transport, broker and service registry which can be accessed by running 
local `micro servers` which connect to the service in the cloud. Hosting is a non-concern at this point for end users 
but we'll provide a `micro run` experience for ourselves and potentially for the local runtimes.

We'll be dogfooding these efforts on an ongoing basis by writing microservices which run on the platform 
and are entirely open source for others to consume. Ultimately our goal is to see the network with 
base level services that don't have to be written or run by anyone else. 

We want to introduce this in August in an invite-only beta mode for our community to test. Most of this 
software will be entirely open source and available to run so anyone can likely connect but we'll 
look to build identity and api tokens in for access control.

The 3 months should give us enough information to drive the rest of the roadmap.

Ultimately we'll provide a Micro Services Network as a global platform for open source services.

## Q3 2019

- **Platform** {Micro Server, Proxy, Runtime, Sync, Network}
  * Evolve the platform => build, run, manage
  * Establish go-micro as micro server
  * Enable connectivity beyond the cloud
  * Continue development of core services
- **Debugging** {Logging, tracing, metrics}
  * Build in observability features

The Q3 (end of October) goal is to deliver additional functionality in the network for observability and management. 
This should include services which handle running services, synchronizing data and provide debugging info at 
the service level.

We want to expand on the build, run, manage effort along with observability and ensure a smooth getting started 
experience.

## Q4 2019

- **Clients** {Go, Python, Ruby, Javascript}
  * Enable multi-language through micro server + grpc
- **Mu spec**
  * Flesh out the mu spec for single file definition
  * Move beyond proto and go

## Q1 2020

- **Services** {Platform, Utility, Orchestration, Web}
  * Continue key service development to 30+ services

## Q2 2020

- **Multi-Cloud**
  * Run on DO, AWS, Azure, GCP
- **Multi-Client**
  * Add additional languages (rust, java, etc}

## 12 month goals

- **Micro as a service**
  * Micro-Server {Network, ...}
  * Multi-Cloud {AWS, Azure, GCP, DO}
  * Multi-Client {Go, Python, Ruby, Javascript, Rust}
  * Services {Platform, Utility, Orchestration, Web}
