---
layout: default
title: Create Services
nav_order: 1
permalink: /getting-started/create-services
parent: Get Started
---
# Create Services

M3O is Micro as a Service. Use the open source tools to build your services and deploy to the platform.

## Deps

You'll likely need

- Go => [https://golang.org/dl/]()
- Git => [https://git-scm.com/downloads]()
- Micro => [https://github.com/micro/micro]()
- Protobuf (Sorry) => [https://github.com/protocolbuffers/protobuf/releases/tag/v3.13.0]()

## New Service

To create a new service simply do 

```
micro new helloworld
```

This generates scaffolding much like Rails for a simple helloworld microservice. Follow any instructions in the output aka make proto.

To run your service locally and ensure it works just start the server and run it.

```
# start the server
micro server

# set local env
micro env set local

# start your service
micro run helloworld
```

To check its actually running do the following

```
# check the status
micro status

# check its registered
micro services

# check the logs
micro logs helloworld
```

And to finally kill it

```
# kill it
micro kill helloworld
```

## Deploy the service

To deploy the service first you'll need to check it into GitHub. We don't yet support local source upload. 

```
# initialise git
cd helloworld && git init && git add . && git commit -m "My helloworld service"

# create a new repo on github and push to it
# assuming you created it, add the remote origin
git remote add origin https://github.com/$user/helloworld.git

# push it
git push origin master

# set the env to platform
micro env set platform

# ensure you've already logged in otherwise
micro login

# now run it
micro run github.com/$user/helloworld
```

It's that simply

## Call service

Check the service is running and call it. Because we built from source, it'll take a couple minutes to start (we'll optimise later)

```
# check status
micro status

# check its registered
micro services

# call it
micro helloworld --name=Alice
```

Note the notation for calling the service. Micro supports dynamic CLI commands, meaning anything in your namespace becomes a subcommand.

```
micro [service] [endpoint] [args]
```

Where endpoint is ommitted we assume its the service name + "Call" method e.g helloworld becomes Helloworld.Call. If it was a Greet method 
we'd assume Helloworld.Greet with the cli command `micro helloworld greet`.

Arguments can be passed through as flags so `--name` is the `Name` field.

If you want a simpler way using pure json and raw methods

```
micro call helloworld Helloworld.Call '{"name": "Alice"}'
```

That also works

## External access

If you want to query via an API, check out the Public API doc under the Get Started section.

TLDR

```
curl -H "Micro-Namespace: $(micro user namespace)" https://api.m3o.com/helloworld
```
