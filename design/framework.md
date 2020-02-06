# Libraries

Micro primarily starts as a set of libraries with strongly defined interfaces that are pluggable. 
We've consolidated this effort into the [go-micro](https://github.com/micro/go-micro) framework.

## Development

Below are the packages and interfaces which we're developing or planning to add in the future.

Note: Libraries will be consolidated into go-micro.

Library	|	Function	|	Description
-------	|	--------	|	-----------
[Service](https://godoc.org/github.com/micro/go-micro#Service)	|	Communication	| Request/Response, Streaming, PubSub
[Config](https://godoc.org/github.com/micro/go-micro/config)	|	Configuration	|	Dynamic config, safe fallbacks, etc
[Sync](https://godoc.org/github.com/micro/go-micro/sync)	|	Synchronisation	|	Data, time, locking
[Runtime](https://godoc.org/github.com/micro/go-micro/runtime)	|	Runtime	|	Service runtime
[Debug](https://godoc.org/github.com/micro/go-micro/debug)	|	Debugging	|	Logging, tracing, metrics, healthchecks
[Monitor](https://godoc.org/github.com/micro/go-micro/monitor)	|	Monitoring	|	Debug analysis and resolution
[Network](https://godoc.org/github.com/micro/go-micro/network) |	Networking	|	Multi-DC networking
Auth	|	Authentication	|	Authentication, authorization, identity
Flow |	Orchestration	|	State machine for managing complex flows of business logic

## Micro

Micro is use for building microservices or more practically distributed systems. It's core concern is communication. 
It's pluggable and runtime agnostic with very simple abstractions for development. 

On the road to v2 defaults should look to support gRPC and kubernetes more natively along with graphql and nats.

Supported registries:
- [x] Multicast DNS (Local)
- [x] Serf gossip (P2P / Mesh)
- [x] Consul (Distributed)

Supported brokers:
- [x] Memory (Local / In Process)
- [x] HTTP (P2P / Registry) => move to grpc?
- [x] NATS (Distributed)

Supported transports:
- [x] HTTP (Local / http/1.1)
- [x] gRPC (P2P)
- [x] Service mesh

## Config

Config is for dynamic configuration. Its used where higher level app configuration is required in process without having to reload 
or restart. Its useful for things related to business logic. 

## Sync

Sync is for distributed synchronisation in all forms; data, time, leadership. Distributed systems and microservices require 
coordination. From a development perspective this can often be difficult. Providing clear abstractions for these that 
are also possible to leverage without external dependencies is valuable. 

Sync ideally becomes the basis for all data storage and any form of synchronisation.

## Runtime

Runtime is the basis for `micro run service`. The library implements the ability to pull the source, build and run the service. 
Ideally a service should be able to declare its own dependencies and they should bootstrap as a DAG. 

Supported sources:
- [x] Git URL

Supported packagers:
- [x] Go binary
- [x] Docker container
- [ ] WASM

Supported runtimes:
- [x] Linux process
- [ ] Docker
- [x] Kubernetes API


