# Authentication

Micro needs an authentication story. In the beginning go-micro had no auth, on the premise that the base requirement 
for distributed systems was solely discovery and communication. Our default experience will continue to operate 
in a zero auth noop model until we can identify how zero trust will work.

## Overview

Auth will include both authentication and authorization. Authentication is the basis for checking whether a user 
or service is "logged in" or has an access token to use across the system. Authorization is used to check 
whether a user or service actually has the privileges to access a resource.

Our story always begins with

- go-micro interface with implementations
  * zero dep default experience
  * industry standard highly available system
  * micro rpc service implementation

The go-micro interface should interop with the rest of the framework then have the capability of being swapped 
out in production for a centralised system. The micro service implemenation enables an anti corruption layer 
to abstract away the underlying infrastructure and further usage through the surrounding micro ecosystem.

## Implemenations

- Zero dep - likely noop because it does not need to be included by default
- JWT tokens - a distributed method of managing authentication
- Casbin, Hydra, OPA - these are becoming open source standards for oauth/rbac and make the most sense here

Ideally we want to standardise around JWT tokens, oauth and/or rbac.

## Design

This is one potential design for auth

```go
type Auth interface {
	// Generate a new account
	Generate(id string, ...GenerateOption) (*Account, error)
	// Grant access to a resource
	Grant(*Account, *Resource) error
	// Revoke access to a resource
	Revoke(*Account, *Resource) error
	// Verify an account has access to a resource
	Verify(*Account, *Resource) error
	// Login to an account
	Login(*Account, ...LoginOption) (*Token, error)
	// Logout from an account
	Logout(*Account, *Token) error
}

// Account represents a user or service account
type Account struct {
	// id of the account
	Id string
	// roles associated
	Roles []string
	// any other metadata
	Metadata map[string]string
}

// Resource represents a service or endpoint
type Resource struct {
	// Name of the source e.g helloworld
	Name string
	// Type of resource e.g service
	Type string
}

// Token is used to access resources
type Token struct {
	// Associated account id
	Id string
	...
}

type GenerateOptions struct {
	// With roles
	Roles []string
	// Associated metadata
	Metadata map[string]string
}

type GenerateOption func(o *GenerateOptions)

func WithRoles(roles ...string) GenerateOption {
	...
}

func WithMetadata(md map[string]string) GenerateOption {
	...
}
```
