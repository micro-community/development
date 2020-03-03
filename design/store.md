# Store

Store is an abstraction for key-value storage.

## Overview

For the majority of time microservices are considered stateless and storage is offloaded to a database 
but considering we provide a framework storage and distributed storage needs to be a core concern.
Micro provides a Store interface for key-value storage and a micro store service as the RPC layer 
abstraction.

## Design

The interface is quite simply

- Read
- Write
- Delete
- List

Where List is moving to simply listing the keys. Read should support key name, prefix, limit and offset. 
Write and Delete operate soley on keys for the time being.

Our implementations are memory, cockroach, etcd and cloudflare. This may extend to others in the future.

## Caching

Caching is a layer to be built on top of the store in store/cache much like registry/cache.


