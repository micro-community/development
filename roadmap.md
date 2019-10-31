# Roadmap

We're tracking and continually evolving the high level roadmap for Micro as a service.

## MVP 

Our MVP goal is to deliver micro as a service. We're taking the open source micro toolkit 
and running it as a service in the cloud. The end state should be a runtime which offers an API, web dashboard, 
CLI, slack bot and service proxy all hosted so that developers don't have to host it themselves. We'll 
provide interconnectivity via a transport, broker and service registry which can be accessed by running 
local `micro` instance which connects to the service in the cloud. 

Hosting is a non-concern at this point for end users but we'll provide a `micro run` experience for ourselves 
and potentially for the local runtimes.

We'll be dogfooding these efforts on an ongoing basis by writing microservices which run on the platform 
and are entirely open source for others to consume. Ultimately our goal is to see the network with 
base level services that don't have to be written or run by anyone else. 

We want to introduce this by end of year as an invite-only beta mode for our community to test. Most of this 
software will be entirely open source and available to run so anyone can likely connect but we'll 
look to build identity and api tokens in for access control.

Ultimately we'll provide a Micro Services Network as a global platform for open source services.

Goals

- [x] Bootstrap Micro OSS in the cloud aka Micro as a service
- [x] Dogfood by writing services or a complete end-to-end service
- [x] Consolidate learnings into roadmap and bug-feature list
- [x] Develop the network to allow connectivity from anywhere
- [ ] Enable sharing of services and discovery
- [ ] Tokenized access control
- [ ] Introduce invite-only service to community 

## Beyond the MVP

Beyond the MVP we want to move on to hosting services to further simplify the developer experience and a full fledged platform 
for microservices. Our goal there will be to allow developers to push services and then observe and interact via the 
managed API, web UI, etc. We'll look to build team based features in after this point along with observability.

- [ ] Hosting services
- [ ] Observability and debugging
- [ ] Team based access control

## Micro as a service

Ultimately we want to deliver micro as a service as a shared platform for microservice development. Anything a company 
ends up building themselves should be available as a shared runtime for all developers everywhere in the world. This should 
not exclude those who want to self host and access the system as if it were part of their own.

### Summarised view

- [ ] Micro services network - a shared platform for service development
- [ ] Multi-Cloud {AWS, Azure, GCP, DO} - highly available and invisible to the user
- [ ] Multi-Client {Go, Python, Ruby, Javascript, Rust} - empower developers in any language
- [ ] Services {Platform, Utility, Orchestration, Web} - base level services delivered by micro itself

### Further breakdown

- [ ] **Network** {Micro Services Network}
  * Global service network
  * Shared system for building microservices
- [ ] **Platform** {Micro Server, Proxy, Runtime, Sync, Network}
  * Evolve the platform => build, run, manage
  * Establish go-micro as micro server
  * Enable connectivity beyond the cloud
  * Continue development of core services
- [ ] **Debugging** {Logging, tracing, metrics}
  * Build in observability features
- [ ] **Services** {Platform, Utility, Orchestration, Web}
  * Continue key service development to 30+ services
- [ ] **Clients** {Go, Python, Ruby, Javascript}
  * Enable multi-language through micro server + grpc
- [ ] **Multi-Cloud**
  * Run on DO, AWS, Azure, GCP
- [ ] **Multi-Client**
  * Add additional languages (rust, java, etc}
- [ ] **Mu spec**
  * Flesh out the mu spec for single file definition
  * Move beyond proto and go
- [ ] **Commands**
  * Auto generate CLI commands based on available services
