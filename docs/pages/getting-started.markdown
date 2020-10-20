---
layout: default
title: Get Started
nav_order: 2
permalink: /getting-started
has_children: true
---

# Get Started
{: .no_toc }

{: .fs-6 .fw-300 }
The fast guide to using the M3O platform

Visit [m3o.com/start](https://m3o.com/start) to get started in minutes.

## Invite

We're currently in invite only mode so ask the team in #m3o-platform for an invite on [slack](https://slack.m3o.com).

## Usage


Install Micro to build, run and manage services locally or on the M3O platform.

```
curl -fsSL https://install.m3o.com/micro | /bin/bash
```

This command makes the rest of your CLI commands run on the M3O platform.

```
micro env set platform
```

Signup to the M3O platform and follow the instructions

```
micro signup
```

See [m3o.com/start](https://m3o.com/start) for the rest of the guide.

## Free Tier

We offer a 'Dev' environment for free usage. It's great for small projects and individual devs.

To use it simply set your environment to the dev env and follow the usual signup flow.

```
micro env set dev
```

External API url's for your services are served on `*.m3o.dev` rather than `*.m3o.app` used by the paid platform.
