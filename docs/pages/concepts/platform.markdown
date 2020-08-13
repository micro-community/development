---
layout: page
title: Platform
keywords: concepts, platform, m3o
tags: [concepts, platform, m3o]
permalink: /concepts/platform
summary: A cloud native platform built for developers
nav_order: 1
parent: Concepts
toc_list: true
---


# Platform


[M3O](https://m3o.com) is a platform for cloud native development.

## Overview

M3O is Micro as a Service. We take the open source framework (v3 and beyond) and host it as a service in the cloud. 
Think managed kubernetes, elasticsearch, etc or how we prefer to see it git and github. Git is a phenomenal tool 
for distributed version control and GitHub provides essentially git hosting as a service.

Micro as a fantastic tool for writing cloud native services. M3O is Micro hosted as a service.

## Getting Started

Visit the [getting started](/getting-started) guide if you just want to get started. You'll need an invite though.

## How it works

M3O is a cloud service which lets you use Micro without having to manage infrastructure. We run highly available 
systems on managed kubernetes in the cloud e.g etcd, nats, cockroachdb and then provide a shared multi-tenant 
experience. From your standpoint its simply Micro hosted for you. For us its scratching an itch to fix 
the pain points with using AWS and other cloud providers.

As a developer you should just be able to focus on writing code but not just a single app, multiple applications 
and various design patterns in a way that's not limiting but removes choice and friction in a way that let's 
you be super productive. Micro + M3O is just that!

So how does it work?

### Environments

Micro has the concept of environments or an "env" built in. These are basically different hosted Micro servers 
you can switch between to do development and run Micro services. There are two built ins, "local" and "platform. 
Local refers to a local server running on "127.0.0.1:8081" and platform refers to the m3o platform where 
we provide an external proxy on "proxy.m3o.com:443".

You can swap between your local env and the platform like so.

```
# platform
micro env set platform

# local
micro env set local
```

### Services

M3O provides a hosted version of Micro, which means anything built into the open source is available for you to use. 
This includes authentication, config, messaging, service discovery, service-to-service calls, storage, etc.

Micro comes with a pre-initialised Go library to run on a Micro server and the platform basically abstracts 
away the underlying infrastructure so you don't have to worry about it.

## Pricing

Our pricing is a flat subscription of $35/month and you get unlimited hosting for your services. That's it.

Cloud and serverless pricing is anxiety inducing in a way that mostly now requires pricing calculators. This 
doesn't make sense to us. We believe to start developers should be given a fair flat subscription price 
and then we charge for additional services you use that are separate to the platform itself. 

## Next Steps

Ask for an invite on the #m3o-platform channel in [slack](https://slack.m3o.com) or join the waitlist on 
the [website](https://m3o.com) and wait to here from us. If you go to slack you'll get an invite asap!
