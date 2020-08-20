# Namespace sharing

This document proposes enabling micro users to invite other future micro users to their namespace.
Sharing a namespace enables a group of users to collaborate on the same set of services, data, config etc when building on M3o.
A v0.1 of our long term goal https://github.com/m3o/dev/issues/379.

## Invite and signup

1. User A invites user B by issuing

```
micro invite user --email userb@gmail.com --my-namespace=yes
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

## Related tickets

https://github.com/m3o/dev/issues/384
https://github.com/m3o/dev/issues/283
https://github.com/m3o/dev/issues/356
https://github.com/m3o/dev/issues/365