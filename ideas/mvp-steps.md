# MVP user journey
Including an overview of differences between local and m3o env implementations where applicable.

Assumptions:
- the user is already familiar with [basic Micro commands](https://dev.m3o.com/getting-started).
- micro cli is installed on the users machine

Note `proxy.micro.mu` should likely become `proxy.m3o.com` or similar (leaving proxy out is likely more elegant).

```sh
$ micro env
  local                             none
* server                            127.0.0.1:8081
  platform                          proxy.micro.mu
```

## 1. `micro env set platform`

With this step the user switches to using our platform as oppose to her `micro server`. But at this point she does not have an account, so  commands should return "Not logged in" or a similar error message:
```
$ micro run github.com/micro/examples/helloworld
Not logged in to env 'server' hosted at 'proxy.micro.mu'.
Please see `micro login help`
```

## 2. Introduce `micro login --new`

- In this step we will create an account for the user.
- We should also create a new namespace for her on the backend automatically.
- The output of this call should return the generated namespace name and that should be written to the local Micro CLI user config file (found at path `~/.micro` by default currently). This can be in any format in that file, it is unimportant and can be changed later. This value will be embedded on each call to the platform in the `Micro-Namespace` header.

Note: For the MVP we decided to hide the concept of namespaces from the users to leave us more time to work out the details.

**Things to work out**:
- **"Right now `micro login` uses the auth of the namespace you're currently in. If we're changing this to always talk to the platform it'll mean the users auth account isn't valid when making a call via the CLI."**

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

At this point the user can use the `platform` environment hosted on m3o.com just like an environment she hosts herself with `micro server` on any box - to the extent of her account.

## 4. The `platform` environment is ready to be used

```
$ micro env
  local                             none
  server                            127.0.0.1:8081
* platform                          proxy.micro.mu
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
