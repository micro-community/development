---
layout: default
title: Public APIs
nav_order: 1
permalink: /getting-started/public-apis
parent: Get Started
---
# Publics APIs

M3O makes your services available via a public http/json API.

Query and access your services in the following ways.

## URL

The public api is available at `https://api.m3o.com`.

## Authentication

Most of our core services are locked down so you'll need to use an API token to access them.

```
# get your user token`
MICRO_API_TOKEN=`micro user token`

# curl the api
curl -H "Authorization: Bearer $MICRO_API_TOKEN" https://api.m3o.com/
```

You should see below or thereabouts

```
{"version": "v3.0.0-beta"}
```

## Generating API Tokens

This section is coming soon but you can otherwise use your own user token for now.

## Request Mapping

Because all services are RPC based, HTTP requests have to be dynamically mapped to services and their endpoints. 
We do this very simply in the manner shown below.

```
# Call helloworld service with Helloworld.Call endpoint
https://api.m3o.com/helloworld/call

# Call hellworld service with Greeting.Message endpoint
https://api.m3o.com/helloworld/greeting/message
```

As you can see if an endpoint matches the service name we can collapse the path so there's no redundancy. 
We additionally map the Call endpoint much like index.html for the web so that you can simply do

```
https://api.m3o.com/helloworld
```

A convenient hack just like the web.

## Setting Namespace

Because your services are in a specific namespace you'll have to set the `Micro-Namespace` header to access them 
via our public api `api.m3o.com`. You otherwise also get a custom url per namespace which you can read about below.

To get your namespace

```
NAMESPACE=`micro user namespace`
```

Then simply set as the header in your call

```
curl -H "Micro-Namespace: $NAMESPACE" https://api.m3o.com/helloworld
```

This will route to your helloworld service as opposed to someone else's!

## Custom URLs

Each user gets a custom URL based on their namespace which is `https://[namespace].m3o.app`

Each of your services is then path based e.g `https://[namespace].m3o.app/[service]`.

For example to route to the helloworld service in the foobar namespace you would do

```
curl https://foobar.m3o.app/helloworld
```

## Authorization

Your namespace is managed by your own set of rules which you can read about in the Authorization guide soon 
or just head to the [Authentication](/tutorials/authentication) tutorial.

