# Runtime

The `micro runtime` is a service runtime used to manage the lifecycle of services regardless of the underlying platform.

## Overview

The runtime consists of two parts:

- [go-micro/runtime](https://github.com/micro/go-micro/tree/master/runtime) - a language agnostic runtime for services
- [micro/runtime](https://github.com/micro/micro/tree/master/runtime) - an rpc service to abstract away the platform

Using this and the command line we have the ability to run services literally anywhere with the same local developer experience.

## CLI

The cli experience consists of

```
# start a service
micro run service --name foobar --version latest --source /path/to/source

# stop a service
micro kill service --name foobar --version latest

# get service status
micro get status --name foobar --version latest
```

In future we'll supporting listing running services

The `--local` flag will be used to only run as local processes.

## TODO

Related to runtime tasks

- micro init - the init (operator) to manage core service which simply calls runtime.Update
- Service Notifier - the notifier which fires individual updates after receiving a new build change
- go-micro docker image - an image specifically for pulling and running from source
- cli commands - implementing the cli commands for run/kill/status

