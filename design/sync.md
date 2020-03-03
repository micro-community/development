# Sync

Sync is a synchronization mechanism for data storage.

## Overview

We need to be able to sync between different Store types and locations. Often we describe 
this as local, regional, global or cloud, edge, dev. Sync provides a way to quite literally 
sync data between different stores and provides a Key-Value abstraction with built in 
data encoding for efficiency and timestamp values.

## Design

Taking liberal use of ideas from https://en.wikipedia.org/wiki/Microsoft_Sync_Framework

Ideally we operate like a computer. Cache misses walk the chain, writes as well.

A computer model

- CPU Register, L1, L2, L3, Ram, Disk

Our model

- memory, disk, database, network
- local, region, global

Or more concretely

- memory, etcd/memcached, cockroach/sql, s3/blob/github
- service, cache, store, blob

## Architecture

Ultimately what we want is to replicate data without the need for data replication, where 
every cache miss results in recursively walking the chain.


