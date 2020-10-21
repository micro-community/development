---
layout: default
title: Invite Users
nav_order: 1
permalink: /getting-started/invite-users
parent: Get Started
---
# Invite Users

Here we outline how to invite other users to the M3O platform, share namespaces and collaborate.

## Invite to the Platform

Every user gets 5 invites to send to other users. These can either just be invites to the platform or 
additional users as part of your own subscription and billing e.g you share a namespace (when using 
the paid plan).

To invite users to the platform

```
micro invite user --email joe@example.com
```

## Sharing a namespace

Sharing a namespace means adding additional users to your account. These users basically share your 
namespace and it allows you all to work together in one place.

To invite a user to your namespace

```
micro invite user --email joe@example.com --namespace $(micro user namespace)
```

Now they should go through signup as per normal

```
micro signup
```

The user should see the following print out during signup.

```
You have been invited to the 'splicing-earthlike-salvage' namespace.
Do you want to join it or create your own namespace? Please type "own" or "join": join
```

Now you both have the ability to work together.

## Additional User Billing

In the case of additional users being added to your namespace, if you're using the paid 'platform' environment 
these will be billed as extra users in your account and subscription.

## Cross Namespace Collaboration

We're working on a feature to unlock cross namespace collaboration where each user writes services in 
their own namespace but can call or share with others in different namespaces. This means you have 
total ownership or can even deploy in the other namespace if granted access.

Coming soon.
