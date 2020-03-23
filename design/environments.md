# Environments

Environments is the ability to manage multiple Micro environments

## Overview

As you move beyond local dev you end up with split envs. We need the ability to manage 
these separate environments from the CLI much like you would with k8s clusters.

## Design

Ideas

```
## Set local proxy
micro env set local https://localhost:8081
micro env set platform https://proxy.micro.mu
```
