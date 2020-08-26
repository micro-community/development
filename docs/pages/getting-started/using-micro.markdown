---
layout: default
title: Using Micro
nav_order: 5
permalink: /getting-started/using-micro
parent: Get Started
---
# Using Micro

M3O is Micro as a Service which means you have access to all the underlying services.

## Services

The core services available to you are

- Authentication
- Service Discovery
- RPC Communication
- Dynamic Config
- Event Streaming
- Key Value Storage
- Runtime Management

We'll walk through these in more depth in the [Concepts](/concepts) section but basically its the OSS 
Micro v3 provided to you with highly available distributed systems beneath the covers.

## Calling Services

To use the services peak into the [service](https://github.com/micro/micro/tree/master/service) directory on GitHub. 
Micro pre-initialises all the services for you so that all you have to do is import the package and call public 
functions made available to you.

Example. Lets make use of calling a service.

```
import (
	"context"

	"github.com/micro/micro/v3/service/client"
	pb "github.com/micro/services/helloworld/proto"
)

req := client.NewRequest("helloworld", "Helloworld.Call", &pb.Request{Name: "Alice"})
rsp := new(pb.Response)
err := client.Call(context.Background(), req, &rsp)
```

If you want to use code generation

```
hw := pb.NewHelloworldService("helloworld", client.DefaultClient)
rsp, err := hw.Call(context.Background(), &pb.Request{Name: "Alice"})
```

## Publish/Subscribe to Events

What about say publishing events?

```
import "github.com/micro/micro/v3/events"

events.Publish("event-topic", map[string]string{"foo": "bar"})
```

And on the subscribe side

```
eventChan, err := events.Subscribe("event-topic")
```

## Storing and Retrieving Data

```
import (
	// we're fixing this
	kv "github.com/micro/go-micro/v3/store"
	"github.com/micro/micro/v3/store"
)

// write the record
store.Write(&kv.Record{
	Key: "foo",
	Value: []byte(`Bar`),
})

// read the record
rec, err := store.Read("foo")

// delete the record
store.Delete("foo")
```

We'll provide further documentation on everything soon but feel free to just talk to us in Slack for now.
