---
layout: default
title: Private Repositories
nav_order: 1
permalink: /private-repositories
parent: Get Started
---

# Using private repositories

Please note that currently only saving one credential is supported, ie. no way to specify it separately for different providers.

## GitHub

[This page](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) explains how to get a personal access token from GitHub.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $your-personal-access-token
```

## GitLab

[This page](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) explains how to get a personal access token from GitLab.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $your-personal-access-token
```

## Bitbucket

[This page](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html) explains how to get a personal access token from Bitbucket.

Issue this command locally to save your personal access token to your local Micro config:
```
micro user config set git.credential $bitbucket-username:$your-personal-access-token
```

Please note the `username` requirement above.