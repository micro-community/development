# Namespace Collaboration

Namespace collaboration is the ability to add existing users as collaborators in your namespace

## Overview

Namespace sharing was the ability to join an existing namespace when creating an account. This meant 
you could add additional users and the namespace owner would be billed. Namespace collaboration 
is the idea of giving an existing user access so you can collaborate, but each of you is billed 
separately.

## Design

Currently namespace access requires an account to be present that was issued by that namespace. 
To expand beyond this we need to enable the ability create accounts as type:collab which link 
to an existing account in the platform in another namespace. This basically allows something 
of a shadow account, where the user has access to the namespace but their actual account is 
still preserved separately. In the event their access is removed, the shadow account is 
simply removed. 

How this will work:

1. User A invites user B to the namespace `micro invite collaborator --email alice@example.com`
2. We find said account that email on the platform and generate a new linked account in User A's namespace
3. User B can continue to operate with their same account but switch namespaces and see User A's services

## Technical

A linked account should be generated with an ID that almost "symlinks" back to the origin

```
# [provider]://[name]@[server]/[namespace]/[id]

micro://alice@m3o.com/project-foobar/faf7b058-f3ab-11ea-adc1-0242ac120002
```

May require augmententing since we are using email as usernames

The ID provides us with information about what server this account exists on (for future federation of accounts and services). 
It includes the name of the account, the namespace it belongs to and its ID. This forms a whole ID for a linked account.

The account itself should also set type:collab so its very clearly marked as not a user or service and is not billed as a user.

## Caveats

The auth service may need to be modified to be able to reference a linked account like this but otherwise some of it 
is a process of discovery and testing. Alternative paths might be to use scopes and heavily modify all the code 
to understand how to use cross namespace scopes. Another way is to create global accounts along with some separate 
mapping table related to authorised namespaces.
