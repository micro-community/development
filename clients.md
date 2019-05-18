# Clients

Micro has mainly focused on the Go programming language via the [Go Micro](https://github.com/micro/go-micro) framework. We're 
now going to move into multi-language via clients built against the Micro Server (TODO). This will involve code generating 
via a gRPC api and then building the clients on top. 

## Development

Languages we want to support from day 1 include {go, py, js, rb, java}

We'll essentially use a gRPC api like so (TBD):

```
syntax = "proto3";

package server;

service Server {
	rpc Call(Request) returns (Response) {};
	rpc Stream(stream Request) returns (stream Response) {};
	rpc Publish(Message) returns (Empty) {};
	rpc Subscribe(Topic) returns (stream Message) {};
	rpc Register(Service) returns (Empty) {};
	rpc Deregister(Service) returns (Empty) {};
}
```
