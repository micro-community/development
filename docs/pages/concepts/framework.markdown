---
layout: page
title: Framework
keywords: concepts, framework, runtime, server
tags: [concepts, framework, runtime, server]
permalink: /concepts/framework
summary: A framework for cloud native development
nav_order: 1
parent: Concepts
toc_list: true
---


# Framework

[Micro](https://micro.mu) is a framework for cloud native development.

## Overview

Micro addresses the key requirements for building distributed systems. 
It leverages the microservices architecture pattern and provides a set of services which act as the building blocks 
of a platform. Micro deals with the complexity of distributed systems and provides simpler programmable abstractions to build on.

## Features

Micro focuses on the concept of <b>Development Runtime Infrastructure</b>, creating separation between the varying 
concerns of development and infrastructure using a runtime as an abstraction layer, then providing entry points 
for external systems to access services run with Micro.

The framework is composed of the following features:

- **Server:** A distributed systems runtime composed of building block services which abstract away the underlying infrastructure 
and provide a programmable abstraction layer. Authentication, configuration, messaging, storage and more built in.

- **Clients:** Multiple entrypoints through which you can access your services. Write services once and access them through every means 
you've already come to know. A HTTP api, gRPC proxy and commmand line interface.

- **Library:** A Go library which makes it drop dead simple to write your services without having to piece together lines and lines of 
boilerplate. Auto configured and initialised by default, just import and get started quickly.


## Runtime Components

The runtime is composed of the following features:

### Clients

Clients are entrypoints into the system. They enable access to your services through well known entrypoints.

- **api:** An api gateway which acts as a single entry point for the frontend with dynamic request routing using service discovery. 

- **cli:** Access services via the terminal. Every good developer tool needs a CLI as a defacto standard for operating a system. 

- **proxy:** An identity aware proxy which allows you to access remote environments without painful configuration or vpn.

### Services

Services are the core services that makeup the runtime. They provide a programmable abstraction layer for distributed systems infrastructure.

- **auth:** Authentication and authorization is a core requirement for any production ready platform. Micro builds in an auth service 
for managing service to service and user to service authentication.

- **broker:** A message broker allowing for async messaging. Microservices are event driven architectures and should provide messaging as a first
class citizen. Notify other services of events without needing to worry about a response.

- **config:** Manage dynamic config in a centralised location for your services to access. Has the ability to load config from multiple 
sources and enables you to update config without needing to restart services.

- **network:** A drop in service to service networking solution. Offload service discovery, load balancing and fault tolerance to the network.
The micro network dynamically builds a latency based routing table based on the local registry. It includes support for multi-cloud networking.

- **registry:** The registry provides service discovery to locate other services, store feature rich metadata and endpoint information. It's a
service explorer which lets you centrally and dynamically store this info at runtime.

- **runtime:** A service runtime which manages the lifecycle of your service, from source to running. The runtime service can run natively locally 
or on kubernetes, providing a seamless abstraction across both.

- **store:** State is a fundamental requirement of any system. We provide a key-value store to provide simple storage of state which can be shared
between services or offload long term to keep microservices stateless and horizontally scalable.

## Service Library

Micro includes a pre-initialised service library built on [go-micro](https://github.com/micro/go-micro) used for distributed systems development. 
Think Rails or Spring but for Go cloud services. Micro builds on the Go programming language to create a set of strongly defined abstractions for writing services.

Normally you'll spend a lot of time hacking a way at boilerplate code in your main function or battling with distributed systems 
design patterns. Micro tries to remove all of this pain for you and create simple building blocks all encapsulated in a single 
service interface.

Each service in the runtime has a corresponding package in [github.com/micro/micro/v3/service](https://github.com/micro/micro/tree/master/service) which 
you can import and use for any need. If you want to publish a message use the broker. If you need to persist data use the store. Or if you just need 
to make service to service calls use the client.

