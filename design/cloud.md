# Cloud

The micro platform (M3) is a cloud based serverless platform for microservices development.

## Overview

This document serves as the design document for our cloud infrastructure and a reference 
point for anyone who wants to understand how it works.

We're operating on all major cloud providers (AWS, Azure, GCP) in a multi-cloud and multi-region 
deployment across US, EU and Asia. We're leveraging DO as a control plane and CloudFlare for 
global load balancing along with KV storage for anything that needs global state.

## Architecture

TODO by jake
