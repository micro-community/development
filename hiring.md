# Hiring

Micro is a globally distributed technology company focused on building developer first focused tools to simplify 
microservice development. We're actively hiring in a global and remote fashion.

If you're interested in being hired join the **#hiring** channel on [slack](https://micro.mu/slack/) or [email us](hello@micro.mu).

## Roles

We're currently hiring for two roles

- Software engineer - focused on the open source side continuing the development of micro and go-micro
- Services engineer - building microservices to power the platform and network

## Apply

Our hiring process is fairly straight forward:

- Get in touch via Email or Slack
  * Tell us why you want to work for micro
  * Tell us one thing missing from micro 
  * Tell us where you can contribute the most
- Provide us links to github/linkedin, etc
- Provide any other info you think is relevant
- Do the code test and send it in upfront

## Interview

We'll do the following:

- Give you a microservice related code test
- Talk with you on slack or jump on a call for 20 mins
- Follow up with online coding/architecture interviews
- Schedule video calls with individual team members

## Code Test 

Pick one of the following tests

### Logging Service

Write a centralised logging solution which ingests logs from files, stores them and makes them available for searching.

The solution should be built as microservices using go-micro. The ingesting, storage and search should be separate 
services. No external database should be used. The solution must work consistently where multiple instances of 
each service are running.

Demonstrate how this can be interacted with via the micro toolkit (api, web ui, cli)

### Auth Service

Write an authentication system that includes user creation, login and sessions.

The solution should be built as microservices using go-micro. User and auth management should be separate services. 
We should be able to validate sessions and check if users are logged in.

Demonstrate how this can be interacted with via the micro toolkit (api, web ui, cli)

### Peer Interface

Write a p2p interface for go-micro and demonstrate its use.

Go micro contains strongly defined interfaces for distributed system requirements. We include client/server interfaces 
that are combined to provide a service. P2P is another form of distributed system architecture where every peer is both a 
client and server.

Demonstrate how a **Peer** interface would be defined within go-micro and provide a basic implementation.
