# Multi Tenancy

M3O will be a multi-tenant platform for microservices development.

## Overview

Micro needs the ability to define multi-tenancy in a clean way that does not require the developer or user 
to deal with the issue. We should be able to segregate data belonging to different users, customers 
and teams paying for isolated platforms.

## Ideas

These are ideas from [@sokolovstas](https://github.com/sokolovstas):

For example I want to use cloud hosting with Micro Platform for my project (Organaza). I login to platform, create new Namespace: Organaza and all my services for this project live there. I want super simple setup to login/oauth/auth (all projects need this)
go.micro.auth.*.social
Auth services that support different social logins by config, all oauth handler are same
e.GET("/auth/:provider/callback/", handler.AuthProviderCallback, middleware.TranslationMiddleware())
e.GET("/auth/:provider/", handler.AuthWithProvider)
we can parse provider name and use any login. For example I use https://github.com/markbates/goth we need to configure it to use our internal Store (where ttl is needed) there is super simple exmaple btw https://github.com/markbates/goth/blob/master/examples/main.go also project is search for maintainers https://blog.gobuffalo.io/goth-needs-a-new-maintainer-626cd47ca37b we can create service that use goth for login. Also it can auth user by email and password from User service.  Auth store session params like token in Store. When I need to check that JWT is valid or exist refresh token I need to use Auth
go.micro.auth.*.register
go.micro.auth.*.recovery
go.micro.auth.*.invite
go.micro.auth.*.confirm
go.micro.auth.*.user
Simple global user service. It used to store info about all users that we have in Namespace and store passwords for plain auth.
go.micro.tenant.*.tenant
Store tenants in Namespace. For Organaza tenants will be client1.organaza.com client2.organaza.com (this can be generic service to extend)
go.micro.tenant.*.tenant-user
Map global user to tenant user to check is user have access to tenant and store tenant specific info. (this can be generic service to extend)
If this all service work fine all that I need is create site web service with landing page and allow new user to register their tenants.
To be DRY all this service can be used by Micro Platform itself:
We can create web site service with registration with different tenants for example organaza.micro.mu. After login it redirect me to current web application with services/dashboards/etc. And from dashboard I spin up new namespace for project. Also I can have a dev/stage namespaces with different settings.
To continue implement we create go.micro.platform.*.tenant that use base go.micro.tenant.*.tenant and add go.micro.platform.*.dashboard
All services specific to Micro Platform (go.micro.platform.*.*) will be store in private repo and use public services from go.micro.tenant.* and go.micro.auth.*
