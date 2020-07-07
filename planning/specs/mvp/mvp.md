# MVP 

The MVP is a cloud (k8s) based managed micro platform. Interaction is focussed around the CLI with only a minimal web presence for taking payments.

## CLI commands
The CLI commands supported in the MVP are defined in [cli.md](cli.md).

## User signup / onboarding
See [here](mvp-steps.md)

## Other
User’s only have 1 namespace for MVP plus access to the `micro` namespace where the core services run. No cross talk across namespaces. 

All users are paid "developer" accounts and charged $35/month.

## Non functional requirements
### Stores
Which stores are supported?
The default store (as configured via `MICRO_STORE`) is `service` which means all store requests will hit our m3o store service which is a distributed, persistent store. 

Users may also choose to use 
- Memory
- File - :warning: this essentially only lasts the lifetime of the process since m3o is Kubernetes based :warning:

:question: Questions
Data durability guarantees? Do we do backups? 
What’s the RPO, RTO?
Encryption at rest?

### Scalability
Manual scaling up of compute/memory as required, by a micro admin.

### SLA 
GMT business hours support via slack. Will have a slack channel dedicated to this. 

### Security
mTLS for all communication within m3o.

Security sense check. No pen testing but ensure
- adequate auth on things like config etc so users can't see things they shouldn't (e.g. dump all our secret keys)
- isolation of core infra like Cockroach and etcd. Only accessed via relevant services.

