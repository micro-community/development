# Namespace sharing

Namespace sharing is the ability to have multiple accounts share a single namespace.

## Overview

This document proposes the ability for micro users to invite other future micro users to their namespace.
Sharing a namespace enables a group of users to collaborate on the same set of services, data, config etc when building on M3o.
A v0.1 of our long term goal https://github.com/m3o/dev/issues/379.

## Invite and signup

1. User A invites user B

By issuing:

```
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
Code here https://github.com/m3o/services/blob/master/signup/handler/signup.go#L340

## Limitations

Currently when a user is invited to join a namespace they are not given their own. This is a limitation which we need to rectify. If 
you have a separate billing account you effectively should have your own namespace. If a user invites you to join their namespace that
should be billed to the owner of that namespace.

Sharing a namespace aka collaborating should be a namespacing scoping feature that allows separate accounts to work together.

## Related tickets

https://github.com/m3o/dev/issues/384
https://github.com/m3o/dev/issues/283
https://github.com/m3o/dev/issues/356
https://github.com/m3o/dev/issues/365
