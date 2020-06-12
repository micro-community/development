# Clients

Multi language clients to access Micro services

## Overview

Multi language clients will enable broader access to Micro services. Our assumption is that all services are written 
using go-micro and with Micro itself, this is Go specific as Rails is with Ruby, Spring is with Java, etc, etc. The same with Android and iOS. Every platform is single language. And so we want to promote backend services to be written with Micro but we want to enable other platforms and language to access those Micro services.

## Design

Multi language clients will first start by being code generated from the protos of each service in the [Runtime](https://github.com/micro/micro) e.g registry, broker, store, etc. We code generate these in [micro/clients](https://github.com/micro/clients). The reason we code generate is to provide a standard api and protocol for speaking 
to the runtime e.g gRPC. Just as http was a standard for the web, gRPC has become a standard for the cloud. 
This enables us to leverage bi-directional streaming, concrete types, etc and evolve the protocol over time.

We will then wrap these code generated clients in idiomatic clients per language and distribute them by the 
various package managers supported by each language e.g Go works with a github import, node uses npm, 
ruby uses gems and so forth.

We will use the micro proxy on port :8081 as the entrypoint for gRPC and this then provides us with a fairly 
standard and fixed way to continue to build those clients. Separately we may address some sort of lightweight 
access model around the micro api or web but for the most part this is the best way to generate clients.

