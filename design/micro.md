# Micro v2

Micro v2 is a reimagining of micro itself as a platform rather than standalone open source project. 
The thesis around this can be found in the [network](https://github.com/micro/development/blob/master/network.md) doc. 
Largely we want to enable collaborative development through a shared platform and network for microservices.

## Getting Started

- [Download](#download-micro)
- [Connect](#connect-to-network)
- [Explore](#explore-the-network)
- [Create](#create-new-service)

### Download micro

From source

```
go get github.com/micro/micro
```

With docker

```
docker pull microhq/micro
```

Release binary... soon

### Connect to network

Startup and connect to the network

```
micro server
```

### Explore the network

List services

```
micro list services
```

Describe a service

```
micro get service go.micro.srv.greeter
```

Query the service

```
micro call go.micro.srv.greeter Say.Hello '{"name": "john"}'
```

### Create new service

Generate a template

```
micro new service
cd service
make
```

Run the service

```
micro run service
```

See its running

```
micro list services
```

Edit to call another service

## TODO

What we need to do to get there

Tooling

- [x] `micro` single boot command for platform
- [x] `micro run` command to run the service
- [ ] `micro env` command to describe the environment`
- [ ] sync local state across the network

Services

- [x] Registry - global registry service
- [x] Runtime - service manager based on go-micro/runtime
- [x] Store - datastore for key-value data
- [ ] Events - proxy equivalent for broker
- [ ] Sync - handle synchronization e.g locking, cron, etc

Extras

- [x] --local to pin to local network (optional opt-out of network)
- [x] dns over http as the resolver: query https://micro.mu/network for the nodes
- [x] github actions to generate release binaries and docker image
- [x] dockerhub webhook for micro latest commit build
- [x] multi-cloud deployment across DO, GCP, Alibaba
- [ ] --token= to specify private routing for tunnel segments e.g dark routing
- [ ] AES tunnel packet level encryption
- [ ] label based routing
  * add node/service metadata to routing table
  * allow proxy to accept label selection
- [ ] auth/identity when joining the network
