---
layout: page
title: Plugins
keywords: concepts, plugins
tags: [concepts, plugins]
permalink: /concepts/plugins
summary: Plugins are a way to extend the functionality of Micro
nav_order: 3
parent: Concepts
toc_list: true
---


# Plugins
{: .no_toc }

Plugins are implementations of Go Micro interfaces which can be used to replace the built in defaults. 

## Overview

At a high level plugins provide the opportunity to swap out underlying infrastructure and dependencies. 
This means a microservice can be written in one way and run locally with zero dependencies but then equally 
run as a highly resilient system in the cloud when using distributed systems to underpin its usage.

A full comprehensive list of plugins can be found at [github.com/micro/go-plugins](https://github.com/micro/go-plugins).

| Directory | Description                                                     |
| --------- | ----------------------------------------------------------------|
| Broker    | PubSub messaging; NATS, NSQ, RabbitMQ, Kafka                    |
| Client    | RPC Clients; gRPC, HTTP                                         |
| Codec     | Message Encoding; BSON, Mercury                                 |
| Micro     | Micro Runtime Plugins                                           |
| Registry  | Service Discovery; Etcd, Gossip, NATS                           |
| Selector  | Load balancing; Label, Cache, Static                            |
| Server    | RPC Servers; gRPC, HTTP                                         |
| Transport | Bidirectional Streaming; NATS, RabbitMQ                         | 
| Wrapper   | Middleware; Circuit Breakers, Rate Limiting, Tracing, Monitoring|

## Usage

Plugins can be added to go-micro in the following ways. By doing so they'll be available to set via command line args or environment variables.

Import the plugins in a `plugins.go` file

```go
package main

import (
	_ "github.com/micro/go-plugins/broker/rabbitmq"
	_ "github.com/micro/go-plugins/registry/kubernetes"
	_ "github.com/micro/go-plugins/transport/nats"
)
```

Create your service and ensure you call `service.Init`

```go
package main

import (
	"github.com/micro/go-micro/v2"
)

func main() {
	service := micro.NewService(
		// Set service name
		micro.Name("my.service"),
	)

	// Parse CLI flags
	service.Init()
}
```

Build your service

```
go build -o service ./main.go ./plugins.go
```

### Env

Use environment variables to set the

```
MICRO_BROKER=rabbitmq \
MICRO_REGISTRY=kubernetes \ 
MICRO_TRANSPORT=nats \ 
./service
```

### Flags

Or use command line flags to enable them

```shell
./service --broker=rabbitmq --registry=kubernetes --transport=nats
```

### Options

Import and set as options when creating a new service

```go
import (
	"github.com/micro/go-micro/v2"
	"github.com/micro/go-plugins/registry/kubernetes"
)

func main() {
	registry := kubernetes.NewRegistry() //a default to using env vars for master API

	service := micro.NewService(
		// Set service name
		micro.Name("my.service"),
		// Set service registry
		micro.Registry(registry),
	)
}
```

## Build

An anti-pattern is modifying the `main.go` file to include plugins. Best practice recommendation is to include
plugins in a separate file and rebuild with it included. This allows for automation of building plugins and
clean separation of concerns.

Create file plugins.go

```go
package main

import (
	_ "github.com/micro/go-plugins/broker/rabbitmq"
	_ "github.com/micro/go-plugins/registry/kubernetes"
	_ "github.com/micro/go-plugins/transport/nats"
)
```

Build with plugins.go

```shell
go build -o service main.go plugins.go
```

Run with plugins

```shell
MICRO_BROKER=rabbitmq \
MICRO_REGISTRY=kubernetes \
MICRO_TRANSPORT=nats \
service
```

