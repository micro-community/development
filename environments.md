# Environments

The environments currently in existence for Micro

## Overview

We have a number of environments, URLs, etc needed to build and manage micro so this serves as a list and maybe 
just a quick overview/summary of architecture in some ways. For the most part there's local, staging and platform.

## Envs

- Local - the developers laptop serving :8080/8081/8082
- Staging - our staging environment served at `*.m3o.dev`
- Platform - the live environment served at `*.micro.mu`

## URLs

Each environment that has been configured will have api, web and proxy exernally exposed terminating TLS via 
Let's encrypt and DNS verification. They are all load balanced via the cloud providers load balancer. 
In the short term we're in UK south in Azure.

Example

- api.micro.mu - the micro api gateway (serves http/json)
- web.micro.mu - the micro web dashboard (serves the browser)
- proxy.micro.mu - the micro proxy (serves grpc)

The equivalent exists for m3o.dev for staging

User apps and projects are served at `*.m3o.app`

## Design

We operate on Kubernetes in the Cloud with the capability of multi-region, multi-cloud but opt to run in 
one cloud provider and one region to begin. Our services are backed by etcd for the registry, nats 
for the broker and cockroachdb for the store. This provides the highly available distributed systems we 
need to operate.

Micro itself is an abstraction layer for distributed systems and kubernetes acts as our runtime. 
Developers interact with micro and are unaware of the underlying infrastructure of hardware much like 
Android for smartphones.

Locally the `micro server` starts individual processes rather than containers and operates in a zero dep mode where the registry is mdns, the broker is point to point http and the store is file based using bbolt. Our primary objective is always to start with a zero dep local model for any new interfaces and to ensure we prioritise local development first since we are a developer first focused company.

## Architecture

Cloud environments operate in a very similar model to H2 at Hailo with an api gateway and web dashboard separately load balanced. We additionally have a grpc proxy for interacting remotely from anywhere, incredibly useful so as not to need a vpn. Beneath that our runtime services {auth, config, debug, network, registry, store} abstract away the underlying infrastructure and make use of shared resources such as nats, etcd and cockroachdb so we don't personally have to write the distributed systems.

A throwback to an old picture from the blog. 

<img src="https://micro.mu/blog/assets/images/regions.png" />

https://micro.mu/blog/2016/04/18/micro-architecture.html

