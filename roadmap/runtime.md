# Runtime

The Runtime is a microservice runtime environment.

## Overview

The Micro Runtime is a microservice runtime environment or better known as a microservice operating system. 
The Runtime builds on the Go Micro Framework, providing service level abstractions of the interfaces 
as RPC. The Runtime started as a toolkit for entrypoints such as CLI, API Gateway and Web dashboard. 
It's since evolved into a full operating environment for microservices which abstracts away the 
complexity of the underlying infrastructure.

## Design

The Runtime starts as a single binary called `micro` available at github.com/micro/micro. It takes 
every Go Micro interface and provides it as a service with RPC endpoints equivalent to the interface. 
These RPC services then leverage the Go Micro interfaces internally making them entirely pluggable. 
So creating a runtime agnostic operating system and anti-corruption layer that forms the basis 
of a platform.

Services included:

- **CLI** - a standard command line interface for the terminal
- **API** - external api gateway serving http/json and sending internal RPC
- **Web** - Web dashboard that provides a proxy for serving web apps as microservices
- **Proxy** - service to service gRPC proxy encapsulating the go-micro client/server
- **Bot** - A Slack bot for ChatOps with all the same commands as the CLI
- **Runtime** - Service deployment
- **Registry** - Service discovery
- **Broker** - Asynchronous pubsub messaging
- **Proxy** - Service to service proxy for gRPC communication
- **Store** - Distributed key-value storage
- **Debug** - Stats, logs and tracing for debugging
- **Auth** - User and service authentication and authorization
- **Config** - Dynamic configuration service
