# Onboarding

This is onboarding for anyone working on the development of micro.

## Overview

We need a set of steps and procedures to bring someone upto speed with micro. This is for anyone who wants 
to get into the depths of working on micro and be a productive contributor to the project.

## Getting Started

- Setup your Go environment
- Install Micro
- Kick the tyres
- Read the docs
- Walk through examples
- Build some services
- Deploy to the platform

## Setup Go environment

Download and install Go from [https://golang.org/dl/](https://golang.org/dl/)

If you're new to Go walk through the tour [https://tour.golang.org/welcome/1](https://tour.golang.org/welcome/1)

Ensure go modules are enabled and your PATH is set:

```bash
export GO111MODULE=on
export PATH=$PATH:$(go env GOPATH)/bin
```

## Install Micro

```bash
go get github.com/micro/go-micro
go get github.com/micro/micro
```

Also, install protobuf and the relevant generators:

```bash
brew install protobuf
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
go get -u github.com/micro/protoc-gen-micro
```

## Kick the tyres

Create a new service

```bash
# Skip GOPATH as we're using Go modules
micro new github.com/micro/mynewservice --gopath=false
```

Compile the proto file

```bash
cd github.com/micro/mynewservice/
protoc --proto_path=. --go_out=. --micro_out=. proto/mynewservice/mynewservice.proto
```

Run the service

```bash
cd github.com/micro/mynewservice
go run main.go
```

Lookup the service

```bash
micro list services
```

Get the service

```bash
micro get service go.micro.srv.mynewservice
```

Call the service

```bash
micro call go.micro.srv.mynewservice Mynewservice.Call '{"name": "John"}'
```

Start the API

```bash
micro api --namespace=go.micro.srv
```

Call via the api

```bash
curl -XPOST -d '{"name": "John"}' http://localhost:8080/mynewservice/call
```

Start the web app

```bash
micro web
```

View at http://localhost:8082

## Read the docs

Skim through the docs at [https://micro.mu/docs/](https://micro.mu/docs/) to get an overview.

Make a note of missing or stale content.

## Walk through examples

Walk through the examples at [https://github.com/micro/examples](https://github.com/micro/examples)


- Start with the basic [helloworld](https://github.com/micro/examples/blob/master/helloworld/main.go)
- See the end to end app example with the [greeter](https://github.com/micro/examples/tree/master/greeter)
- How to do bidirectional [streaming](https://github.com/micro/examples/tree/master/stream)
- Simple [pubsub](https://github.com/micro/examples/tree/master/pubsub) via the go-micro/broker

## Build some services

Write some services using [https://github.com/micro/go-micro](https://github.com/micro/go-micro) to explore the framework.

Example services can be found here [https://github.com/microhq](https://github.com/microhq)

One potential idea is user/service authentication:

- Write an identity service which handles user and service accounts
- Write an auth service which handles authentication and check against the identities
 
## Deploy to the platform

Get credentials from the team to deploy to the micro platform
