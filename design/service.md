# Service

The definition of a service right now is a go-micro service which contains a client and server. 
We want to expand the scope of service execution beyond go-micro.

Services both serve and consume which is why they encapsulate a client and server. Clients 
are able to Call, Stream and Publish. Servers are able to Handle requests, streams and Subscribe 
to messages.

Microservices conceptually are loosely coupled services with a bounded context. They are able 
to perform both synchronous and asynchronous forms of communication. Hence micro including 
both sync via Transport and async via the Broker.

## Overview

In terms of long term strategy, we want to turn everything into a service. To do this we need 
a multi-pronged strategy. With the following.

- A service can be written natively using the go-micro framework
- A service can be integrated using the multi-language client libraries
- A service can be created via a single command `micro service --name foo --endpoint http://localhost:9090`


