# MVP CLI 

The following is a list of CLI commands for the MVP

## Overview

Below is the bare minimum commands required to build, run and manage Micro services

Note: All other commands can be seen in `--help` but not guaranteed to work. 

```
micro server
micro signup
micro login
micro env
micro new
micro run
micro update
micro kill
micro status
micro logs
micro call
micro config
```

## `micro new`
Command generates new skeleton micro service from a template - service, function, api, web. 
Where possible the skeleton should be complete and successfully compile straight away with no further changes. This is not possible for `api` and `web` services since they have dependencies on some other service(s) that cannot be inferred 

## `micro server` 
Command runs full micro platform. Runs all the component pieces required.

##  `micro run`
Command to run a service on the platform. Should work with both local and m3o with the same format. 

Multiple modes
- `micro run <path to local directory>` - deploys and runs source code found on local machine on the micro server
- `micro run <gitHub.com/public/repo>` - deploys and runs code found at the github location
- `micro run <something under github.com/micro/services>` - run one of the services defined in the github.com/micro/services repo. For example, `micro run payments` will deploy and run github.com/micro/services/payments

The above order is also precedence order, so if a user has a directory `payments` in the current working directory then `micro run payments` will run the code in that directory rather than deploying github.com/micro/services/payments.

:warning: Out of scope
- Uploading and running local code on m3o 
- Private github.com repos

## `micro update`
Command to update a running service to latest version. Does a delete, then create so will cause some downtime. 

## `micro kill`
Command to stop a running service and remove from the runtime.

## `micro status`
Command to display status of the currently running services in this namespace.

## `micro logs`
Command to display logs for the service. 

:warning: Out of scope
Streaming logs from the platform.

## `micro call`
Command to call endpoints on a micro service 

## `micro config`
Command to set and get values in the config store. 

:question: Questions
- Is it OK for secrets?

## `micro env`
Command to set / add the environment being used (local machine, m3o, something else). m3o details should be baked in to the micro binary.

## `micro signup`

Command to signup to the platform. Initially a built-in command, will ask for email/password and verify email via OTP

## `micro login`
Command to login to the platform; Will simply be username / password prompt where we use email as the username.


