---
layout: page
title: Framework
keywords: concepts, framework, go-micro, interfaces
tags: [concepts, framework, go-micro, interfaces]
permalink: /concepts/framework
summary: A Go framework for distributed systems development
nav_order: 1
parent: Concepts
toc_list: true
---


# Framework
{: .no_toc }

Micro includes a framework called [go-micro](https://github.com/micro/go-micro) (sometimes referred to as Go Micro) which is 
used for distributed systems development. Think Rails or Spring but for Go cloud services. Go Micro builds on the Go programming language 
to create a set of strongly defined abstractions for writing services.

Normally you'll spend a lot of time hacking a way at boilerplate code in your main function or battling with distributed systems 
design patterns. Go Micro tries to remove all of this pain for you and create simple building blocks all encapsulated in a single 
service interface.

## Interfaces

Below is a high level overview of the packages/interfaces within the framework. Detailed design docs can be found in 
[development/design](https://github.com/m3o/dev/tree/master/design). Anything you can't find here 
just check out [pkg.go.dev](https://pkg.go.dev/github.com/micro/go-micro/v2).

### Auth

Auth is built in as a first class citizen. Authentication and authorization enable secure zero trust networking by providing every service an identity and certificates. This additionally includes rule based access control.

### Broker

The broker provides an interface to a message broker for asynchronous pub/sub communication. This is one of the fundamental requirements of an event 
driven architecture and microservices. By default we use an inbox style point to point HTTP system to minimise the number of dependencies required 
to get started. However there are many message broker implementations available in go-plugins e.g RabbitMQ, NATS, NSQ, Google Cloud Pub Sub.

### Client

The client provides an interface to make requests to services. Again like the server, it builds on the other packages to provide a unified interface 
for finding services by name using the registry, load balancing using the selector, making synchronous requests with the transport and asynchronous 
messaging using the broker. 

The  above components are combined at the top-level of micro as a **Service**.

We additionally provide some other components for distributed systems development:

### Codec

The codec is used for encoding and decoding messages before transporting them across the wire. This could be json, protobuf, bson, msgpack, etc. 
Where this differs from most other codecs is that we actually support the RPC format here as well. So we have JSON-RPC, PROTO-RPC, BSON-RPC, etc. 
It separates encoding from the client/server and provides a powerful method for integrating other systems such as gRPC, Vanadium, etc.

### Config

Config is an interface for dynamic config loading from any number of sources which can be combined and merged. Most systems actively require configuration 
that changes independent of the code. Having a config interface which can dynamically load these values as needed is powerful. It supports 
many different configuration formats also.

### Debug

Micro provides a built in debugging experience through stats, logs and tracing. Debugging is a separate concern from monitoring. Debugging is a form of observability that's deeply integrated into the go-micro framework. The idea here is to mimic Go's runtime tooling or thereabouts e.g runtime stats, stdout and stderr logs, debug stack traces.

### Server

The server is the building block for writing a service. Here you can name your service, register request handlers, add middeware, etc. The service 
builds on the above packages to provide a unified interface for serving requests. The built in server is an RPC system. In the future there maybe 
other implementations. The server also allows you to define multiple codecs to serve different encoded messages.

### Store

The store is a simple key-value storage interface used to abstract away lightweight data storage. We're not trying to implement a full blown sql dialect 
or storage, just simply the ability to hold state that would otherwise be lost in stateless services. They store interface will become a building block 
for all forms of storage in the future.

### Registry

The registry provides a service discovery mechanism to resolve names to addresses. It can be backed by consul, etcd, zookeeper, dns, gossip, etc. 
Services should register using the registry on startup and deregister on shutdown. Services can optionally provide an expiry TTL and reregister 
on an interval to ensure liveness and that the service is cleaned up if it dies.

### Selector

The selector is a load balancing abstraction which builds on the registry. It allows services to be "filtered" using filter functions and "selected" 
using a choice of algorithms such as random, roundrobin, leastconn, etc. The selector is leveraged by the Client when making requests. The client 
will use the selector rather than the registry as it provides that built in mechanism of load balancing. 

### Transport

The transport is the interface for synchronous request/response communication between services. It's akin to the golang net package but provides 
a higher level abstraction which allows us to switch out communication mechanisms e.g http, rabbitmq, websockets, NATS. The transport also 
supports bidirectional streaming. This is powerful for client side push to the server.

