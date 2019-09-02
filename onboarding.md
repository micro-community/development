# Onboarding

This is onboarding for anyone working on the development of micro.

## Overview

We need a set of steps and procedures to bring someone upto speed with micro. This is for anyone who wants 
to get into the depths of working on micro and be a productive contributor to the project.

## Getting Started

- Setup your Go environment
- Install Micro
- Kick the tyres
- Walk through examples
- Build some services
- Deploy to the platform

## Setup Go environment

Download and install Go from [https://golang.org/dl/](https://golang.org/dl/)

If you're new to Go walk through the tour [https://tour.golang.org/welcome/1](https://tour.golang.org/welcome/1)

## Install Micro

```
go get -u github.com/micro/go-micro
```

## Kick the tyres

Create a new service

```
micro new github.com/micro/service
```

Run the service

```
cd github.com/micro/service
go run main.go
```

Lookup the service

```
micro list services
```

Get the service

```
micro get service go.micro.srv.service
```

Call the service

```
micro call go.micro.srv.service Example.Call '{"Name": "John"}'
```

Start the API

```
micro api --namespace=go.micro.srv
```

Call via the api

```
curl -XPOST -d '{"name": "John"}' http://localhost:8080/example/call
```

Start the web app

```
micro web
```

View at http://localhost:8082

## Walk through examples

Walk through the examples at [https://github.com/micro/examples](https://github.com/micro/examples)

And services here [https://github.com/microhq](https://github.com/microhq)

## Build some services

Write some services using [https://github.com/micro/go-micro](https://github.com/micro/go-micro) to explore the framework.

## Deploy to the platform

Get credentials from the team
