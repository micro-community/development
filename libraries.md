# Libraries

Micro primarily starts as a set of libraries with strongly defined interfaces that are pluggable.

## Development

Below are the libraries which we're developing or planning to add in the future.

Note: Libraries will be consolidated into go-micro.

Library	|	Function	|	Description
-------	|	--------	|	-----------
[Go Micro](https://github.com/micro/go-micro)	|	Communication	| Request/Response, Streaming, PubSub
[Go Config](https://github.com/micro/go-config)	|	Configuration	|	Dynamic config, safe fallbacks, etc
[Go Sync](https://github.com/micro/go-sync)	|	Synchronisation	|	Data, time, locking
[Go Run](https://github.com/micro/go-run)	|	Runtime	|	Service runtime
[Go Debug](https://github.com/micro/go-debug)	|	Debugging	|	Logging, tracing, metrics, healthchecks
Go Monitor	|	Monitoring	|	Debug analysis and resolution
Go Auth	|	Authentication	|	Authentication, authorization, identity
Go Flow |	Orchestration	|	State machine for managing complex flows of business logic
Go Init |	Initialisation	|	Manages initialisation of options, flags and env vars

## Micro

Micro is use for building microservices or more practically distributed systems. It's core concern is communication and nothing 
more. It's pluggable and runtime agnostic with very simple abstractions for development. 

On the road to v2 defaults should look to support gRPC and kubernetes more natively along with graphql and nats.

Supported registries:
- [x] Multicast DNS (Local)
- [x] Serf gossip (P2P / Mesh)
- [x] Consul (Distributed)

Supported brokers:
- [x] Memory (Local / In Process)
- [x] HTTP (P2P / Registry) => move to grpc?
- [ ] NATS (Distributed)

Supported transports:
- [x] HTTP (Local / http/1.1)
- [ ] gRPC (P2P)
- [ ] Service mesh (Distributed)

## Config

Config is for dynamic configuration. Its used where higher level app configuration is required in process without having to reload 
or restart. Its useful for things related to business logic. 

## Sync

Sync is for distributed synchronisation in all forms; data, time, leadership. Distributed systems and microservices require 
coordination. From a development perspective this can often be difficult. Providing clear abstractions for these that 
are also possible to leverage without external dependencies is valuable. 

Sync ideally becomes the basis for all data storage and any form of synchronisation.

## Run

Run is the basis for `micro run service`. The library implements the ability to pull the source, build and run the service. 
Ideally a service should be able to declare its own dependencies and they should bootstrap as a DAG. 

Supported sources:
- Git URL

Supported packagers:
- Go binary
- Docker container
- WASM

Supported runtimes:
- Linux process
- Kubernetes API

## Init

Init is for initialising options

### Overview

Micro is a pluggable ecosystem and the majority of its tooling has bespoke options per plugin. 
These are easily initialised in code but difficult to add via env var and flags. Go Init 
look to solve this problem tying options to flags/envvars automatically.

### Design 

```go
type Options interface {
  // Initialise options based on context
  Init(Context) error
  // Name of options e.g registry
  String() string
}

type Context interface {
  // Get a value
  Get(name string) Value
  // Set a value
  Set(name, option func(Value) error)
  // Scope to namespace
  Namespace(name string) Context
  // Namespace of context
  String() string
}

// A value retrieved from env/flags
type Value interface {
  Scan(v interface) error
  Bytes() []byte
  Int() int
  String() string
  Bool() bool
}
```

### usage

```go
type Options struct {
  Foo string
}

// Initialise values based on context
func (o *Options) Init(ctx Context) error {
  ctx.Namespace("registry").Set("foo", func(v Value) error {
    o.Foo = v.String()
  })
}

func (o *Options) String() {
  return "registry" 
}
```

### flag/env

```
--registry_foo=bar
REGISTRY_FOO=bar
```

