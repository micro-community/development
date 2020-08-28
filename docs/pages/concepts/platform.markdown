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


[**M3O**](https://m3o.com) is a platform for cloud native development.

## Overview

M3O is Micro as a Service. We take the open source [**Micro**](https://github.com/micro/micro) framework (v3 and beyond) 
and host it as a service in the cloud. Think managed kubernetes, elasticsearch, etc or how we prefer to see it git 
and github. Git is a phenomenal tool for distributed version control and GitHub provides essentially git hosting as a service.

Micro is a fantastic tool for writing cloud native services. M3O is Micro hosted as a service.

## Features

We're starting with a Dev tier focused on small teams and individuals. You likely don't want to manage infrastructure 
and want to focus on Go based microservices development in the cloud. That's what we're here for. Where Netlify 
is the frontend. Micro is the backend and M3O is the host.

We're offering a Dev tier to start which provides the following:

- Fully managed Micro as a Service
- Public API endpoints
- Private repo support
- Upto 5 collaborators
- Upto 10 services
- Fair usage limits

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

### Hosting

M3O hosts Micro in the cloud using various cloud providers in different regions. Initially during the beta phase 
we're starting with Scaleway in Europe so that we can focus primarily on users needs and do it in a cost effective 
manner. Over time we'll move on to AWS, GCP and Azure in the US and Asia.

So how do you access it?

### Environments

Micro has the concept of environments or an "env" built in. These are basically different hosted Micro servers 
you can switch between to do development and run Micro services. There are two built ins, "local" and "platform". 
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

Our pricing is a subscription of $35/dev/month. For that you get the ability to deploy upto 10 services, invite 5 people to 
collaborate with, support for private git repos and secure public api endpoints for your services. 

Cloud and serverless pricing is anxiety inducing in a way that mostly now requires pricing calculators. This 
doesn't make sense to us. We believe to start developers should be given a fair flat subscription price 
and then we charge for additional services you use that are separate to the platform itself. 

## Future 

In the future we'll introduce different pricing tiers for teams and enterprise that include support and SLAs along with 
additional features for metrics, logs, etc. For now we really want to help small teams and individual developers.

## Next Steps

Ask for an invite on the #m3o-platform channel in [slack](https://slack.m3o.com) or join the waitlist on 
the [website](https://m3o.com) and wait to here from us. If you go to slack you'll get an invite asap!
