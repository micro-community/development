# Wishlist

A wish list of things we really want to build but just don't have time for right now.

## Overview

The wish list is stuff we really want to build but we need to push out to the future. It might be things we 
do on hack days or just things we revisit at a later date. Its a good place for ideas with full knowledge 
that its not our priority.

## The List

- developers.micro.mu - a portal for interactive tutorials and learning
- `micro env clone [env-from] [env-to]` - I want to be able to deploy my local app with one command to an other env. Env setup must be similarly simple 1 command solution (`micro env create`)
- dynamic cli that turns any command into a service call - `micro store write foo bar` => go.micro.store Store.Write {"foo": "bar"}

## Ben's Dream

```
# My Micro Dream Experience

I want my services to be language agnostic and have SDKs for all major languages

I want to call other services like I would any another package

I want to write APIs and know they're available in every way the client could dream of

I want to require a dependancy in my service and have it immediately available and configured for my environment

I want a seamless experience for the clients of my public API, with auto-generated docs and versioned client libraries

I want async messaging to be a first class citizen just like async / rpc is

I want to manage workspaces at a top level (e.g. xcproject and xcworkspace for Obj-C)

I want to use a mono-repo to encapsulate all of my services

I don't want non-master branches to impact users, but I want to be able to call via the API them by setting a flag

I want services to be so simple that I don't need to use templates

I want configuration to be at a workspace level when it is common to more than one service

I want my configuration to be language agnostic
```
