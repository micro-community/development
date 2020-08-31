---
layout: page
title: Authentication
keywords: micro
tags: [micro]
permalink: /tutorials/authentication
summary: Authentication and authorization
parent: Tutorials
nav_order: 2
toc_list: true
---

# Authentication and authorization
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}
---

Micro and the `micro server` comes with fine tunable authentication and authorization capabilities.
Out of the box, the `micro server` is open. This means anyone can call any endpoints, look at all data, config, and so on.

## Basics - Securing an installation

Rules determine what resource a user can access. The default rule is the following:

```sh
$ micro auth list rules
ID          Scope           Access      Resource        Priority
default     <public>        GRANTED     *:*:*           0
```

The `default` rule enables access to all resources. Now, if we want to limit access, we can replace this with a rule
that will only enable logged in users to access the `micro server`.

If we list the current accounts on the micro server, we can see the following:

```sh
$ micro auth list accounts
ID                                          Scopes      Metadata
163fcd54-1da4-43a6-be1b-d5019dec3952        service     n/a
307066c3-2fb4-4652-ab4c-5f252175e398        service     n/a
59f83328-84ac-4044-8bac-4c59a39c4061        service     n/a
99df788f-f4ad-4474-8516-db35667569f0        service     n/a
a9b3102f-81d8-4dc4-a811-c8bf1e22ba6c        service     n/a
default                                     admin       n/a
```

Let's ignore the service accounts for now and focus on the 'admin' scoped account with the id 'default'.
Now, we have to options before removing the default account: either log in as admins with username 'default' and password 'password':

```sh
$ micro login
Enter email address: default
Enter Password: 
Successfully logged in.
```

and change the password (Note: this is not implemented yet), or create a new account and delete the default. It's a good practice to not leave default accounts in an installation for security reasons, so let's do the latter.

```sh
# This command deletes the 'default' user account
micro auth delete account default
```

To verify that the account is gone, we can list accounts again:

```sh
$ micro auth list accounts
ID                                          Scopes      Metadata
163fcd54-1da4-43a6-be1b-d5019dec3952        service     n/a
307066c3-2fb4-4652-ab4c-5f252175e398        service     n/a
59f83328-84ac-4044-8bac-4c59a39c4061        service     n/a
99df788f-f4ad-4474-8516-db35667569f0        service     n/a
a9b3102f-81d8-4dc4-a811-c8bf1e22ba6c        service     n/a
```

Nice! Now we just have to create an account with the `micro auth create account` command:

```sh
# This command creates an admin account to be used.
$ micro auth create account --secret mystrongpass --scopes admin me@email.com
Account created.
```

```sh
$ micro auth list accounts | grep me
me@email.com					admin		n/a
```

Now we just have to change the rules to not allow unauthenticated requests. First, let's add a new rule which we will name `onlyloggedin` as the aim is to only allow
logged in users to call `micro server:

```sh
# This command creates a rule that enables only logged in users to call the micro server
micro auth create rule  --access=granted --scope='*' --resource="*:*:*" onlyloggedin
```

Here, the scope `*` is markedly different from the `<public>` scope we have seen earlier when doing a `micro auth list rules`:

```sh
$ micro auth list rules
ID			    Scope			Access		Resource		Priority
onlyloggedin	*			    GRANTED		*:*:*			0
default			<public>		GRANTED		*:*:*			0
```

While public means anyone callers, `*` any logged in callers. Before we remove the default rule, there is one more rule to set up: we need to ensure that
the login functionality can be called by users who are not logged in :)). Let's call this `authpublic`:

```sh
# This command creates a rule that enables anyone to call login and auth related endpoints
micro auth create rule  --access=granted --scope='' --resource="service:auth:*" authpublic
```

Now, let's remove the default rule.

```sh
# This command deletes the 'default' rule - the rule which enabled anyone to call the 'micro server'.
$ micro auth delete rule default
Rule deleted
```

Now, from this point all calls should fail:

```sh
$ micro auth list rules
Error listing rules: {"Id":"auth","Code":401,"Detail":"Unauthorized call made to auth:Rules.List","Status":"Unauthorized"}
```

Let's hope we remember our password and we can log in (hint: it's `mystrongpass`):

```sh
$ micro login
Enter email address: me@email.com
Enter Password: 
Successfully logged in.
```

After login, `micro auth list rules` and other commands should be functional again:

```sh
$ micro auth list rules
ID              Scope           Access      Resource                  Priority
authpublic      <public>        GRANTED     service:auth:*   0
onlyloggedin    *               GRANTED     *:*:*                     0
```

This tutorial will be continued with more advanced topics in the near future.
