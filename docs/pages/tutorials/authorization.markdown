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

This tutorial is mainly aimed at the `local` env, but the same commands should work with your M3O `platform` account too.

Micro and the `micro server` comes with fine tunable authentication and authorization capabilities.
Out of the box, the `micro server` is open. This means anyone can call any endpoints, look at all data, config, and so on.

## Basics - Securing an installation

Rules determine what resource a user can access. The default rule is the following:

```sh
$ micro auth list rules
ID          Scope           Access      Resource        Priority
default     <public>        GRANTED     *:*:*           0
```

The `default` rule enables access to all resources. Now, if we want to limit access, we can replace this with a rule that will only enable logged in users to access the `micro server`.

If we list the current accounts on the micro server, we can see the following:

```sh
$ micro auth list accounts
ID                                          Scopes      Metadata
admin                                       admin       n/a
```

Now, we have to options to secure our installation: either log in as admins with username 'admin' and password 'micro':

```sh
$ micro login
Enter email address: default
Enter Password: 
Successfully logged in.
```

and change the password with `micro user password set`, or create a new account and delete the default. It's a good practice to not leave default accounts in an installation for security reasons, so let's do the latter.

We can do this by creating an account with the `micro auth create account` command:

Note: Creating new accounts on the platform are billed as "Additional Users" at a monthly fee of $35/month.

```sh
# This command creates an admin account to be used.
$ micro auth create account --secret mystrongpass --scopes admin me@email.com
Account created.
```

```sh
$ micro auth list accounts | grep me
me@email.com					admin		n/a
```

After our account is ready, we can log in with `micro login` and delete the default 'admin' account:

```sh
$ micro login
Enter email address: me@email.com
Enter Password: 
Successfully logged in.

$ micro auth delete account admin
Account deleted.
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
