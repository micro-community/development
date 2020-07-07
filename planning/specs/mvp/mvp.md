# MVP 

The MVP is a cloud (k8s) based managed micro platform. 

## CLI commands
The CLI commands supported in the MVP are defined in [cli.md](cli.md).

## User signup / onboarding
`micro env set platform` - point the user’s CLI to m3o platform

`micro login --otp`

Login and signup is handled using email OTP. Command generates an email with a token to be used as OTP on the command line. 

After inputting the password: 
- if the user has an account they will be auth’ed and a token returned which is stored on the machine in `.config` 
- if the user does not have an account the user will be asked to visit m3o.com/subscribe.html 

The subscribe page will ask for payment, once payment is taken a token is returned. Account and namespace are created at this point
This payment token is input in to the CLI which completes user account creation and returns a token to be stored in `.config` for future interactions.

## Other
User’s only have 1 namespace for MVP plus access to the `micro` namespace where the core services run. No cross talk across namespaces. 

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
GMT business hours support via slack

### Security
mTLS for all communication within m3o.

Security sense check. No pen testing but ensure
- adequate auth on things like config etc so users can't see things they shouldn't (e.g. dump all our secret keys)
- isolation of core infra like Cockroach and etcd. Only accessed via relevant services.

