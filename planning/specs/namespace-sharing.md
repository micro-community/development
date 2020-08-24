# Namespace sharing

Namespace sharing is the ability to have multiple accounts share a single namespace.

## Overview

This document proposes the ability for micro users to invite other future micro users to their namespace.
Sharing a namespace enables a group of users to collaborate on the same set of services, data, config etc when building on M3O.


A v0.1 of our long term goal https://github.com/m3o/dev/issues/379.

## Invite and signup

1. User A invites user B

By issuing:

```
# invite the user and send them an email
micro invite user --email joe@example.com --namespace foobar
# alternatively micro invite user --email joe@example.com --namespace $(micro user namespace)
```

2.  User B registers

The signup flow for new users who are already invited to an existing namespace will change slightly:

```
micro signup
Looks like you have been invited to an existing namespace 'namespace-name' by 'user'.
Do you want to join this namespace or create your own? [own|join]?
```

If user selects 'own' namespace, everything happens like before.
If user selects 'join', instead of generating a new namespace, we simply skip that part and create a new account in an existing namespace.
Code here https://github.com/m3o/services/blob/master/signup/handler/signup.go#L340. 

Note: The user should not be asked to enter payment details when joining a namespace. 

## Billing

The account owner who created the namespace and the billing subscription is billed for the additional users which join a namespace. 
If the user is simply invited to the platform they are billed separate and given their own namespace.

## Limitations

Currently when a user is invited to join a namespace they are not given their own. This is a limitation which we need to rectify. If 
you have a separate billing account you effectively should have your own namespace. If a user invites you to join their namespace that
should be billed to the owner of that namespace.

Sharing a namespace aka collaborating should be a namespacing scoping feature that allows separate accounts to work together.

## Collaboration

Collaboration is the ability to share separate namespaces. A user is issued an account scope which gives them access to other namespaces. 
This exists in the scope field of an account token so that it can be checked in flight. It is likely mapped as a separate table in 
the auth service which allows us to see what namespaces an account has access to. When a token is created, we inject the scopes 
for all the namespaces into the token or the one specified. 

- User A has their own account
- User B is invited to create an account
- User A invites user B to collaborate on a namespace

```
# invite user B to M3O and send them an email
micro invite user --email joe@example.com

# invite user B to collaborate and send them an email
micro invite collaborator --email joe@example.com --namespace $(micro user namespace)
```

The user account must exist on the platform for us to invite as a collaborator to the namespace otherwise we have to email them an 
invite to the platform separately before they can become a collaborator. Inviting a collaborator means they have access to 
our namespace via scopes rather than having their account created within the same namespace.

## Future Works

- Ability to remove users
- Ability to remove collaborators

## Related tickets

- https://github.com/m3o/dev/issues/384
- https://github.com/m3o/dev/issues/283
- https://github.com/m3o/dev/issues/356
- https://github.com/m3o/dev/issues/365
- https://github.com/m3o/dev/issues/394
