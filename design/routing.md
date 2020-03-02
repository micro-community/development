# Routing

This document describes service routing and versioning requirements.

## Overview

In the long term we want to support api versioning, label based routing and per web app subdomains. 
The idea is that a product architecture is constantly evolving with multiple versions in flight 
at any given time but also the need for feature based testing and custom subdomains for web apps 
for syntactically nicety.

## Concerns

* Label based routing (Micro-X Headers route via metadata)
* URL Versioning routes to service versions
* Per web app sub domains

## Label Based Routing

Label based routing is the concept of feature flagging through a set of labels/metadata which 
match a specific version/instance of a service thats running. In a microservices architecture 
this will be a cross cutting feature change that occurs against many different services. 

Label based routing offers us the ability to specify a Micro-Version header of Micro-X label 
that's associated with a service's associated metadata, right down to the granularity 
of metadata associated with a specific endpoint. We can then pass this in the request 
and allow it to filter down the chain.

Additionally with label based routing we'd also tackle the concern of weighted routing to 
be able to slowly ramp up traffic to a new feature change.

Labels could be applied in the service itself or dynamically in the router where it maintains a 
routing table.

... Example to follow

## URL Versioning

URL versioning is specifically targeted at api versions of a service and api versioning itself. 
This is usually a non-concern anywhere else. For apis we want to be able to version them so 
that they can be progressed with breaking changes. This is standard practice in the industry.

Versioning can either be done through headers or via /v0-9+ in the url. We propose to stick 
with URL versioning for now until there's a greater demand for header based versioning. In 
any event Label based routing will support Micro-Version which will do routing for it.

URL versioning currently routes to a specific service version e.g /v1/foo to go.micro.api.v1.foo. 
We may want to move to applying the version against a service version specifically in 
the registry.

## Per Web App Sub Domains

Currently we're serving web apps on a path. This is great for composing a single domain as microservices 
but in the case of products we likely want a single subdomain to represent it. It would be valuable 
to have subdomain based routing for web apps. Specifically as follows.

Assuming service go.micro.web.foobar

- web.micro.mu/foobar - routes to foobar web app
- foobar.web.micro.mu - routes to foobar web app
- foobar-latest.web.micro.mu - routes to latest foobar
- foobar-branch.web.micro.mu - routes to branch version
