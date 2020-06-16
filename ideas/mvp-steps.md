# MVP user journey
Including an overview of differences between local and m3o env implementations where applicable.

Assuming the user is already familiar with [basic Micro commands](https://dev.m3o.com/getting-started) she can immediately get started:

The environment of the user will be either `local` or - more likely - `server` if she ever used `micro server` locally:

```sh
$ micro env
  local                             none
* server                            127.0.0.1:8081
  platform                          proxy.micro.mu
```

## 1. `micro env add customEnv proxy.micro.mu && micro env set customEnv`

With this step the user clearly states her desired environment name. But at this point she does not have an account, so  commands should return "Not logged in" or a similar error message:
```
$ micro run github.com/micro/examples/helloworld
Not logged in to env 'envName' hosted at 'proxy.micro.mu'.
Please see `micro login help`
```

## 2. Introduce `micro login --new` or `micro register`

In this step we will create an account for the user. We can take the environment name from the call and create the environment in the same step too.

At this point the user can either use the environment or get a payment required error message - this is up to us.

```
$ micro run github.com/micro/examples/helloworld
Payment is required. Please see `micro account help` for payment information. 
```

## 3. Introduce command to pay

`micro account pay` or `micro pay` could be introduced and used to print out something like this:

```
$ micro account pay
Your current balance is: $0. To top up please go to m3o.com/pay?email=user@gmail.com
```

The user does not need to log in on the website as the email address which is part of the Stripe payment window/data and can be used to reconcile who paid what amount.

At this point the user can use her environment hosted on m3o.com just like an environment she hosts herself with `micro server` on any box - to the extent of her account.

## 4. Use the m3o platform with the custom environment

```
$ micro env
  local                             none
  server                            127.0.0.1:8081
  platform                          proxy.micro.mu
* envName                           proxy.micro.mu
```

With the accont paid for and the environment selected, the Micro commands will work the same way, albeit using different implementations:

## Overview of major differences between local/default implementations and ones used by m3o

Focusing on initial commands during the MVP user journey.

### `micro run [url]`

```
micro run github.com/micro/examples/helloworld
```

#### Default implementation

Checks out git repositories to a local folder (eg. `$TMPDIR/github-com-micro-examples`) and runs the code from there.

#### K8s implementation

A generic Go image downloads checks out the git repositories and runs the code from there. **We need to modify how `micro server` is ran in live, see [discussion here](https://github.com/micro/development/pull/221)**

Alternative implementation (we still haven't decided which one to implement apparently):

Push a prebuilt (with GitHub actions or similar) specific image to a registry accessible by our m3o runtime and run that image.

### `micro logs -f [runtime name]`

#### Default implementation

The logs come from the server's file system and get streamed to the CLI command by the runtime service logs endpoint. (Note: multi node setup might be borked, does not matter for MVP.). The logs, coming from the filesystem are unstructured and it's not trivial to seek exact lines (https://github.com/micro/go-micro/blob/master/runtime/default.go#L432)

#### K8s implementation

The logs come from K8s in a structured and easy to query way and then get streamed to the client by the runtime service logs endpoint. **This is broken at the moment and needs to be fixed for MVP.**

### `micro run [local path]`

#### Default implementation

The local code gets gzipped and uploaded to the server through the `server.Upload` endpoint, which uncompresses the zip and writes the folder into `$TMPDIR/uploads/[service name]` then does a `go run [folder path]`.

#### K8s implementation

**This implementation is nonexistent, ie. entirely broken.**

What should happen is the local code gets gzipped and uploaded to the server and saved to store or written straight to the store to begin with. After this we need to get the code into the pod/container. This step is to be defined and likely involves architecture work.
