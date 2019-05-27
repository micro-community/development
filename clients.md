# Clients

Micro has mainly focused on the Go programming language via the [Go Micro](https://github.com/micro/go-micro) framework. We're 
now going to move into multi-language via clients built against the Micro Server (TODO). This will involve code generating 
via a gRPC api and then building the clients on top. 

Languages we want to support from day 1 include {go, py, js, rb, java}

## API

We'll essentially use a gRPC api like so (TBD):

```
syntax = "proto3";

package server;

service Client {
	rpc Call(Request) returns (Response) {};
	rpc Stream(stream Request) returns (stream Response) {};
	rpc Publish(Message) returns (Empty) {};
	rpc Subscribe(Topic) returns (stream Message) {};
	rpc Register(Service) returns (Empty) {};
	rpc Deregister(Service) returns (Empty) {};
}


```

We'll then code generate via this api and have gRPC clients that can be used in any language. Although the goal then 
is to level up and build idiomatic clients around this in every language to provide a truly beautiful developer experience. 
It's clear that gRPC has its benefits but its clients are not great beyond Go. From a microservices perspective 
enabling that via higher level clients makes the most sense.

## Server

Looking at the developer experience for adopting an api, cache, search, database or anything else it's clear the experience 
needs to be dropping a server and then providing client libraries in any language. This is sort of a frictionless thing 
which augments the app development experience without having to totally buy into a framework.

The micro server will essentially do this for microservices. 
