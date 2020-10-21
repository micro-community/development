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

## Usage


Install Micro to build, run and manage services locally or on the M3O platform.

```
curl -fsSL https://install.m3o.com/micro | /bin/bash
```

Set your environment to 'dev' for the free environment.

```
micro env set dev
```

Signup and follow the instructions

```
micro signup
```

See [m3o.com/start](https://m3o.com/start) for the rest of the guide.

## Paid Tier

Dev is an environment for free usage. It's great for small projects and individual devs but if you want 
to run a scalable production ready service or product you'll want to use the M3O Platform paid plan. 
We'll provide higher resource limits and more scalable infrastructure along with support and SLAs.

To use the M3O Platform set the env to 'platform' and signup for a paid subscription.

```
# use the platform
micro env set platform

# signup to the platform
micro signup
```

Your service API URLs on the platform are served at `*.m3o.app` rather than `*.m3o.dev`.

See [**m3o.com/platform**](https://m3o.com/platform) for the quick start.
