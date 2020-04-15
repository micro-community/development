# Multi Tenancy

M3O will be a multi-tenant platform for microservices development.

## Overview

Micro needs the ability to define multi-tenancy in a clean way that does not require the developer or user 
to deal with the issue. We should be able to segregate data belonging to different users, customers 
and teams paying for isolated platforms.

## Ideas

These are ideas from [@sokolovstas](https://github.com/sokolovstas):

For example I want to use cloud hosting with Micro Platform for my project (Organaza). I login to platform, create new Namespace: Organaza and all my services for this project live there. I want super simple setup to login/oauth/auth (all projects need this)

```
go.micro.auth.*.social
```

Auth services that support different social logins by config, all oauth handler are same
e.GET("/auth/:provider/callback/", handler.AuthProviderCallback, middleware.TranslationMiddleware())
e.GET("/auth/:provider/", handler.AuthWithProvider) we can parse provider name and use any login. 

For example I use https://github.com/markbates/goth we need to configure it to use our internal Store 
(where ttl is needed) there is super simple exmaple btw https://github.com/markbates/goth/blob/master/examples/main.go 
also project is search for maintainers https://blog.gobuffalo.io/goth-needs-a-new-maintainer-626cd47ca37b we can create service that use goth for login. Also it can auth user by email and password from User service.  Auth store session params like token in Store. 

When I need to check that JWT is valid or exist refresh token I need to use Auth

```
go.micro.auth.*.register
go.micro.auth.*.recovery
go.micro.auth.*.invite
go.micro.auth.*.confirm
go.micro.auth.*.user
```

Simple global user service. It used to store info about all users that we have in Namespace and store passwords for plain auth.

```
go.micro.tenant.*.tenant
```

Store tenants in Namespace. For Organaza tenants will be client1.organaza.com client2.organaza.com (this can be generic service to extend)

```
go.micro.tenant.*.tenant-user
```

Map global user to tenant user to check is user have access to tenant and store tenant specific info. (this can be generic service to extend). If this all service work fine all that I need is create site web service with landing page and allow new user to register their tenants.

To be DRY all this service can be used by Micro Platform itself:

We can create web site service with registration with different tenants for example organaza.micro.mu. After login it redirect me to current web application with services/dashboards/etc. And from dashboard I spin up new namespace for project. Also I can have a dev/stage namespaces with different settings.

To continue implement we create `go.micro.platform.*.tenant` that use base `go.micro.tenant.*.tenant` and add `go.micro.platform.*.dashboard`
All services specific to Micro Platform (`go.micro.platform.*.*`) will be store in private repo and use public services from 
`go.micro.tenant.*` and `go.micro.auth.*`


## Implementation

Firstly, mutli-tenancy is implemented by Micro and not a concern of the go-micro framework. Micro (the runtime) has an understanding of tennancy and is responsible for it, the services built on top of the runtime however should not need to have any notion of tennancy; whilst the runtime is mutli-tennant, services are single-tennant. Tennany is dependant on identity and therefore requires auth to work. If the auth implementation used is noop, the runtime should assume we're operating in a single tennant mode and default to using the default namespace as defined in `micro/internal/namespace` (at the time of writing this is currently *go.micro*, but we will likely move to just *micro* soon.).

### Cross-Tennant Access

As a rule, tennants cannot access any services outside their own namespace (each tennant is a "namespace" in micro), however there are some exceptions. All tennants can read/write to the default namespace, but tennants can only call (read) the runtime namespace, not deploy or amend services (write). Whilst the registry will restrict the services returned in a given namespace, it will be the responsibility of auth to enforce the rules noted above.

### API / Web

Micro API and Web both have a namespace flag, which now can be used to filter the services using a prefix (e.g. "go.micro.web" will only return the services in the format "go.micro.web.X"), or if the value "domain" is provided, they will determine the namespace on a request-by-request b asis using the domain. As a fixed (hardcoded) rule, all micro.mu and development hosts will use the default namespace, and other subdomains will use the subdomains to determine namespace. For example: "foo.m3o.app" will use the "foo" namespace, "staging.myapp.com" will use the "staging" namespace and a top level domain such as "myapp.com" will use the default namespace.

### Determining the namespace

Namespaces are set in the request header at the start of the request by the auth wrapper (`micro/auth/wrapper`), which is injected into both the API and Web servers. All runtime services can use the `internal/namespace` package, `NamespaceFromContext` function to determine the current namespace. If the request originated from an external call, the namespace key will be set on the context and this will be returned. If the request was a service=>service request, we will get the namespace from the auth account of the calling serviice. If the namespace is still unknown (an unauthenticated service made a request), we fallback to the default namespace.


### Using the namespace in the runtime

Whilst runtime services need to be responsible for managing multi-tennancy, they do not need to know how it's determined. They should simply scope the resources a context can access using the contexts namespace: `namespace.NamespaceFromContext(ctx)`. Resources should be persisted so that the unique identifiers do not need to be globally unique, but only unique to the namespace. For example, if namespace A writes a config key "foo", it should not conflict with the same key previously written by namespace B, this goes back to services not needing to know about mutli-tennancy.

There is an exception to the above rule: the registry. Because micro service names use the format [namespace,type,alias], we already have the concept of namespace baked into go-micro. Hence, if a service in the "foo" namespace tries to register a service named "bar.web.x", they'll get a forbidden (403) error. In the future, we will likely move away from this as it prevents using mutli-tennancy for staging and test enviroments (in these scenarios the same services could exist in mutliple namespaces with the same name).