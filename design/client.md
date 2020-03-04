# Client

Client is a service for managing client device access to Micro

## Overview

[Clients](clients.md) outlines the different types of protocols and entrypoints we'll support 
for multi-language clients (go-micro, grpc code generated, client libraries). Here we're 
looking to discuss specifically the serving of /client through the micro api for client library 
access to services. This ultimately is an endpoint that provides access to all services 
and requires gatekeeping of client devices.

## Design

The client is composed of the following:

- Service - go.micro.service.client - used for storing access control info
- API - go.micro.api.client - used for accessing services
- Web - go.micro.web.client - Used for managing access via a UI

The client api consists of an rpc api service served at /client via the micro api. It has 
a fixed proto interface based on [go-micro/client](https://godoc.org/github.com/micro/go-micro/client#Client) 
of Call/Stream/Publish. We only begin with Call which is request/response based.

Our proto is the following

```
syntax = "proto3";

package go.micro.api.client;

// Client is the micro client api
service Client {
	// Call allows a single request to be made
	rpc Call(Request) returns (Response) {};
	// Stream is a bidirectional stream
	rpc Stream(stream Request) returns (stream Response) {};
	// Publish publishes a message and returns an empty Message
	rpc Publish(Message) returns (Message) {};
}

message Request {
	string service = 1;
	string endpoint = 2;
	string content_type = 3;
	bytes body = 4;
}

message Response {
	bytes body = 1;
}

message Message {
	string topic = 1;
	string content_type = 2;
	bytes body = 3;
}
```

Our first usage of this is the [node](https://github.com/micro/clients/tree/master/node) client.

## Access Control

Ultimately with clients having access to call any service we need to be able to limit them via 
ACLs. We will do so either by offloading to the auth service with Roles/Scopes for Resources/Services 
or by defining a simply set of ACL rules stored in the client service.

This is merely a whitelist where we can govern based on IP, user, role, service endpoint, etc.

## Clients

Clients will use localhost:8080/client or api.micro.mu/client in prod. To start this is simply 
http/json but we will support proto and grpc-proto also. 

Languages or clients we will support

- node
- angular
- js
- go
- ruby
- python
- ...
