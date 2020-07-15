# MVP 

The MVP is Micro as a Service.

## Overview

The Micro Platform is a cloud native platform built for developers. Its a fully managed Micro built on k8s in the cloud. For MVP the interaction is primarily CLI driven with only a minimal web presence for taking payments. 

## CLI commands
The CLI commands supported in the MVP are defined in [cli.md](cli.md).

## User signup / onboarding
See [user journey](user-journey.md)

## Other
User’s only have 1 namespace for MVP plus access to the `micro` namespace where the core services run. No cross talk across namespaces. 

All users are paid "developer" accounts and charged $35/month.

## Non functional requirements
### Stores
Which stores are supported?
The default store (as configured via `MICRO_STORE`) is `service` which means all store requests will hit our m3o store service which is a distributed, persistent store backed by cockroach. 

If users deviate from the model of using `DefaultStore` they might be running 
- Memory - which should work as expected
- File - :warning: this essentially only lasts the lifetime of the process since m3o is Kubernetes based so will not work as expected :warning:

In case of any support queries we should be pushing users to the `DefaultStore` model.

:question: Questions
Data durability guarantees? Do we do backups? 
No guarantees and no backups

Encryption at rest?
No encryption

### Scalability
Manual scaling up of compute/memory as required, by a micro admin.

### SLA 
GMT business hours support via slack. Will have a slack channel dedicated to this. 

### Security
mTLS for all communication within m3o.

Security sense check. No pen testing but ensure
- adequate auth on things like config etc so users can't see things they shouldn't (e.g. dump all our secret keys)
- isolation of core infra like Cockroach and etcd. Only accessed via relevant services.

### Config
Config should only be readable by something with an account for that namespace. For now it is OK for something to have namespace wide access but eventually config will be scoped per service with only accounts with admin role being able to view everything.

:warning: Out of scope
- encrypted config
