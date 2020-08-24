# Platform

The micro platform (M3O) is a cloud native platform for microservices development.

## Overview

This document serves as the design document for our cloud infrastructure and a reference 
point for anyone who wants to understand how it works.

Historically
```
We're operating on all major cloud providers (AWS, Azure, GCP) in a multi-cloud and multi-region 
deployment across US, EU and Asia. We're leveraging DO as a control plane and CloudFlare for 
global load balancing along with KV storage for anything that needs global state.
```

Today we operate in a single region in Europe using managed kubernetes on scaleway. Our plan 
will be to scale up that region and then move on to others based on a need driven by customers.

## Design

The platform exists in the repository [micro/platform](https://github.com/micro/micro/tree/master/platform) and builds on
[Micro](https://github.com/micro/micro) itself. We build services in [m3o/services](https://github.com/m3o/services) so 
that we can provide Micro as a Service.

## Components

Top down:

### Entrypoints

We serve any environment through 3 global endpoints:

- api.micro.com- the `micro api` served over https
- proxy.micro.com - the `micro proxy` served over https

The api is used as the http/json inbound. The proxy uses gRPC for remote access via the CLI and other services.

### Runtime

Internally we're running `Micro` as single replicas to abstract away the underlying infrastructure.

## Infrastructure

We use managed kubernetes on every cloud provider. Our shared infrastructure for each service is as follows.

- etcd - registry
- nats - broker
- cockroachdb - store

