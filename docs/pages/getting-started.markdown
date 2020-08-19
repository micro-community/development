---
layout: default
title: Get Started
nav_order: 2
permalink: /getting-started
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

## Using private repos

Please note that currently only saving one credential is supported, ie. no way to specify it separately for different providers.

### GitHub

[This page](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) explains how to get a personal access token from GitHub.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $your-personal-access-token
```

### GitLab

[This page](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) explains how to get a personal access token from GitLab.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $your-personal-access-token
```

### Bitbucket

[This page](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html) explains how to get a personal access token from Bitbucket.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $bitbucket-username:$your-personal-access-token
```

Please note the `username` requirement above.