# Cloud

Micro Cloud is managed Micro as a Service.

## Overview

Cloud infrastructure management is a pain and Kubernetes as the abstraction for the cloud is a lie. 
There are still per environment quirks that must be dealt with and the overhead of per env management 
is painful. Cloud attempts to solve these problems as a service that understand how each 
cloud provider operates.

Micro Cloud deals with providing managed Micro as a Service through cloud automation that 
abstracts away the underlying cloud envs, providing a single way of managing multiple 
systems in a multi-cloud env.

## Design

Located at cloud.micro.mu or web.micro.mu/cloud. The dashboard is the location where you go to manage 
Micro environments/namespaces. Much like you'd see the ability to create Kubernetes clusters 
in managed GKE, we provide managed M3O. Where you can name our environment, define its namespace 
and domain and then have a fully automated platform bootstrapped in minutes.

The dashboard will be backed by the Cloud service go.micro.cloud which deals with automation via 
RPC calls. It will provide abstracted information about different regions and their deployments.

## Owners

Cloud is a service owned by Jake.
