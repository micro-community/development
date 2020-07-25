---
layout: page
title: Clients
keywords: concepts, clients
tags: [concepts, clients]
permalink: /concepts/clients
summary: Multi-language clients to interact with Micro services
nav_order: 3
parent: Concepts
toc_list: true
---


# Clients
{: .no_toc }

Clients are soon to be released multi-language clients for Micro.

Find the repository at [github.com/micro/clients](https://github.com/micro/clients).

## Overview

Clients provide a way to access Micro services through multiple languages. Our expectations are that Micro 
defines a standard model for cloud services development as Rails and Spring did for their respective 
languages, platforms and ecosystems. We believe Go will be the dominant language in the Cloud and so 
Micro primarily focuses on Go. 

Every platform however has it's language and so we need to enable 
access to Micro services. Web has javascript, enterprise has Java, mobile has objective C and... etc, etc.

## Design

Find the start of the design doc [here](https://github.com/m3o/dev/tree/master/design/clients)

Multi language clients will first start by being code generated from the protos of each service in the 
[Runtime](https://github.com/micro/micro) e.g registry, broker, store, etc. We code generate these in 
[micro/clients](https://github.com/micro/clients). The reason we code generate is to provide a standard api and protocol for speaking 
to the runtime e.g gRPC. Just as http was a standard for the web, gRPC has become a standard for the cloud. 
This enables us to leverage bi-directional streaming, concrete types, etc and evolve the protocol over time.

We will then wrap these code generated clients in idiomatic clients per language and distribute them by the 
various package managers supported by each language e.g Go works with a github import, node uses npm, 
ruby uses gems and so forth.

We will use the micro proxy on port :8081 as the entrypoint for gRPC and this then provides us with a fairly 
standard and fixed way to continue to build those clients. Separately we may address some sort of lightweight 
access model around the micro api or web but for the most part this is the best way to generate clients.

