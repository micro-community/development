# Platform Scaling

This document describes the scaling properties of Micro and the platform

## Overview

Here we explain the individual scaling properties of every Micro service and any limitations related to them. 
The design may evolve and this document may change but it serves as the place to look when thinking about 
scaling up.

TODO: We need to make each section uniform with TLDR bullets e.g Can be scaled horizontally (green tick).

## Design

Micro is designed for the majority as a platform and runtime agnostic architecture. Abstracting away the 
underlying infrastructure into the concept of Development Runtime Infrastructure so it acts as a 
runtime / anti-corruption layer on top of infra, allowing development to be done against a set of 
strongly defined APIs. Because of this the underlying systems can be swapped out for scalability, 
persistence, etc and Micro mostly operates as stateless.

## Contents

- [Services](#services) - Describes service scaling and limitations
- [Certificates](#certificates) - Describes our use of Let's Encrypt
- [Authentication](#authentication) - Describes authentation on the platform
- [Infrastructure](#infrastructure) - Describes the infrastructure we use

## Services

Non comprehensive list of services

- [api](#api) - http/json (port 8080) entrypoint for public access
- [proxy](#proxy) -  RPC (port 8081) entrypoint for CLI and remote env access
- [auth](#auth) - Authentication and authorization
- [broker](#broker) - Asynchronous message broker
- [config](#config) - Dynamic configuration
- [events](#events) - Event streaming and storage
- [network](#network) - Service to service internal network proxy
- [registry](#registry) - Service directory and endpoint explorer
- [router](#router) - Route lookup for service addresses
- [runtime](#runtime) - Process and service lifecycle manager
- [store](#store) - Data storage and persistence


### API

The API is the public entrypoint via http/json on port 8080 or 443 in production at api.m3o.com. It converts 
requests to an RPC format and sends to the appropriate backend service based on registry or extracted 
endpoint definitions encoded in the service endpoint metadata.

Scaling
  - Can be scaled horizontally
  - All state lives in the registry or other sources
  - Uses Let's encrypt for TLS (limitations noted under [certificates](#certificates)
  
Limitations
  - Does not perform any rate limiting
  - Calls underlying services for routing and auth
  - In the event the system fails it fails
  - In the event lets encrypt fails it wont start
  - Not yet dynamically configurable via config
  
  ### Proxy
  
  The proxy is the CLI and remote access entrypoint via gRPC port 8080 or 443 in production at proxy.m3o.com. It 
  basically provides an "identity aware" proxy that lets you access remote environments. Useful for CLI to offload 
  any core concerns. Is a public/external entrypoint like the API, not meant for service to service unless 
  that service is say local dev to prod/staging.
  
  Scaling
    - Can be scaled horizontally
    - All state lives in the router and other sources
    - Uses Let's encrypt for TLS (limitations noted under [certificates](#certificates)
    
  Limitations
    - Similar limitations to the API
    - Uses first part of gRPC path for service name rather than host
    - Set to use network via MICRO_PROXY, probably not the best config
    
  ### Auth
  
  Auth manages authentication and authorization. It is the single source of truth for all accounts management and 
  access rules within the system. It is potentially a bottleneck where rules and access info has to constantly 
  be accessed from it. It leverages the store aka cockroachdb for persistence of all state which means auth 
  is per region unless replicated.
  
  Scaling
    - Can be horizontally scaled
    - ...
    
  Limitations
    - Potentially the bottleneck for all usage
    - Maintains internal memory map of namespaces
    - Schema may need to be evaluated for scaling
    - Isolates accounts per namespace
    - Services cache rules for 30 seconds and then re-request
    - Does not operate under true JWT semantics despite issuing tokens
    - Operates per region based on the store
  
  ### Broker
  
  Broker is a simple asynchronous message that allows fire-and-forget usage. It offers pubsub semantics and 
  simply lets you publish or subscribe from a topic. Additionally supports Queues based on the underlying 
  implementation. We use NATS in production and point to point http locally.
  
  Scaling
    - Can be scaled horizontally
    - Depends on the underlying NATs for scaling
 
  Limitations
    - Isolation is done by prefixing namespace to the topic
    - Not adequately tested in a production situation
    - Does not provide any rate limiting
    - Operates per region based on NATs
  
  ### Config
  
  Config is a dynamic configuration service for all level requirements
  
  Scaling
    - Can scale horizontally
  
  Limitations
    - Its unclear of its security properties, could potentially leak config to others
    - Config paths are error prone
    - There is no versioning history
    - Can only operate in a per region setting based on underlying store
  
  ### Events
  
  Events is an event streaming and storage service. Its goal is to operate like a persistent event stream and database from 
  which you can read a historic set of events for history, audit, etc. Our usage depends on nats-streaming-server which is 
  a counterpart to NATS, soon to be merged into NATS itself.
  
  Scaling
    - Can scale horizontall
    - Depends on nats-streaming-server cluster and cockroach store
 
  Limitations
    - Is a per region deployment
    - Requires hard coded topics for storage
    - Does not have any synchronization for races
  
  ### Network
  
  Network is a service to service gRPC proxy with built in clustering for creating service meshes. It's used for all network 
  communication internally, configured by settting MICRO_PROXY env var to its address or the Proxy option on a client. 
  The network is a service. Which means it contains the same wrappers and configuration as everything else. It depends 
  on the registry router at present to load routes and uses the Router interface along with the Proxy interface.
  
  Scaling
    - Can be scaled horizontally
    
  Limitations
    - Routes are per region
    - Will fail in the event of registry failure
    - May throwaway routes where services fail to register and expire out
  
  ### Registry
  
  The registry is a service directory and endpoint explorer. It is the central source of truth for all services. Services 
  register with the registry on start and periodically heartbeat registrations. All entries are TTLed and expire after a 
  given period. We use etcd to persist entries.
  
  Scaling
    - Can scale horizontally
    - Depends on etcd cluster in production
    
  Limitations
    - Mainains internal leases in the etcd go-micro implementation
    - Should theoeretically continue to operate when registering against a different node
    - Etcd has an upperbound limit of 8Gb for storage
    - If the registry fails all discovery fails
  
  ### Router
  
  The router is a routing table used by the client to lookup routes. It creates a cutdown table from the registry and 
  enables more performant inflight request operation by maintaining an in memory table. It also allows filtering 
  queries based on route fields like address, network, etc.
  
  Scaling
    - Can scale horizontally
  
  Limitations
    - If it fails to read the registry then we have no routes
    - Can potentially have stale routes for up to 2 minutes
    - Operates in a per region context based on the registry
  
  ### Runtime
  
  The runtime is a process and service lifecycle manager. It allows services to be run locally as processed (Go via Git) or 
  on kubernetes as containers using a default preset image such as micro/go-micro or micro/micro. The runtime maintains 
  internal state using the store to know what should be running and correlates with what is running. Each runtime 
  manages some internal state about namespaces and the status of services it knows about so that it does not have to 
  save in the store or constantly check kubernetes.
  
  It also maintains a key per hour for a set of events which have occured. This is so that if multiple are running, they 
  can simply poll one key to know of state changes rather than listing out all the rows in the table to know whats 
  changed. This reduces the load on the database.
  
  Scaling
    - Operates on a per region basis based on whats written to the store aka cockroach
    - Can do global replication with a global storage such as cloudflare KV workers (API rate limited)
    - Can be scaled horizontally
    
  Limitations
    - Each node maintains some internal state which may be a race condition when getting status
    - Operates on a regional basis based on the storage
    - Does not provide the ability to define the number of replicas
  
  ### Store
  
  The store is a data storage and persistent layer mostly based on key-value usage with support for key expiry. Locally 
  uses file storage and in production uses cockroach DB. Mimics a cassandra like experience.
  
  Scaling
    - Can be scaled horizontally
    - Requires cockroach DB nodes to be scaled in a cluster
    - Mostly just an RPC access layer
    
  Limitations
    - Can fail read queries where a table doesn't yet exist
    - Does not perform any type of isolation or rate limiting as of yet
    - Could be a weak point for security if compromised

## Authentication

Core services make use of the auth interface rather than calling the auth service itself. This is so we can decentralised 
access control at that layer. They still load access rules but just don't need to call auth to make service calls themselves. 
Otherwise all services must be issued a JWT token from the auth service. Services have a built-in client cache so that 
rules are only loaded every 30 seconds, still a scaling limitation. Authentication uses the store for persistence so 
we are currently limited to per region config.

## Certificates

We use Let's Encrypt to provide us TLS certificates for public access through api.m3o.com and proxy.m3o.com. 

Certificates use Cloudflare DNS challenge + Certmagic / Cockroach Storage. The api and proxy define env vars 
for the custom domains they support. A challenge stores a txt record to validate DNS authority and then 
stores the certificates so that we can persist across restarts.

Scaling
  - Can be scaled horizontally in a region
  - A shared cockroach DB means multiple instances of api/proxy use the same certs in a region
  - Random renewal interval ensures only one node will renew on any given day (attempted 7 days before expiry)

Limitations
  - There is no locking around renewal so if multiple instances have coordinated random renewal it may have multiple attempts
  - Certs are stored in cockroach which means unless cockroach is replicated globally each region will renew independently
  - Let's encrypt has a rate limit. In the event of a failure we will block ourselves
  
TODO
  - Introduce synchronization around renewal
  - Replicate one certificate globally per domain e.g s3 storage
  - Potentially offload the cert management to a different ingress
  
## Infrastructure

We make use of shared resources and highly available distributed systems as our underlying infrastructure so we can offload 
scaling concerns. We start with a cloud provider, in our case Scaleway and run managed kubernetes provided by them. 
We are currently on one node in one region in Europe. We then layer on etcd, NATs and cockroach for the registry, 
broker/events and storage.

### Kubernetes

Used for the runtime to manage the lifecycle of processes and services

Scaling
  - Can scale nodes horizontally using managed K8s
  - Not yet autoscaled
  
Limitations
  - Kubernetes operates on a per region basis
  - We are currently limited to Europe on Scaleway
  
### Etcd

Used as the service registry to maintain a single source of truth for services and endpoints

Scaling
  - Operates as a cluster so can be scaled horizontally using helm
  
Limitations
  - Has a max upperbound of 8Gb for storage
  - Clusters need to be 3, 7, 9 nodes for raft concensus
  - Can be the single failure point for all things ala zookeeper at hailo
  - Depends on persistent volumes
  - Per region deployment
  
### NATS

Nats is used for the broker (async messaging) and for events using nats-streaming-server

Scaling
  - Can be scaled horizontally as a cluster
  - Using helm to scale the number of replicas
  
Limitations
  - Must scale in a coordinated fashion like etcd we believe
  - Nats-streaming requires a persistent volume (currently set at 1GB)
  - Per region deployment
  
## CockroachDB

CockroachDB is used for data storage. Its a distributed sql database based on google spanner. Uses multi-raft and its own SS tables 
form of storage called Pebble. We are running this in production as 1 node but would run a 3 node cluster when k8s nodes are 
scaled up.

Scaling
  - Can scale horizontally
  - Currently run as 1 node
  - Uses 100Gb persistent volume per node

Limitations
  - Per region deployment for now
  - Global replication might be an enterprise feature
  - All the problems of a distributed data store on k8s
  - Self managed operations
