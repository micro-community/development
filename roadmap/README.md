# Product Roadmap

This is the product roadmap for Micro Services, Inc.

## Overview

Micro is a developer first focused company. Our primary goal is to enable developers 
to build, share and collaborate on Micro services. We do this via an open source framework, 
runtime and a platform for Micro services development.

## Objectives

Our goals over the long term

- Build **M3O** - Micro as a Service - a fully managed microservices platform
- Onboard Users - Invite the community first to build services on the platform
- Create Services - Create value add Micro services on the platform for users
- Launch Marketplace - Offer the ability to buy, sell and share Micro services 

## Phase 1

Build Micro as a Service. Launch an MVP. Test a business model. Grow adoption.

- [Platform MVP](platform.md) - a cloud platform for microservices development
  * Provides "Micro as a Service"
  * Invite only for community
  * Public cloud hosting (free)
  * Onboard users 10 at a time
- [Paid product](https://m3o.com) - Fully managed Micro Platform
  * Provides "Micro as a Service" to customers
  * Namespace per customer in Kubernetes
  * Subscription based $35/user/month
  * SaaS Community, Developer and Team tiers
- [Platform Launch](https://github.com/m3o/dev/issues/357) - Announce to the world
  * Public launch
  * Signup 100+ customers
  * Docs, blogs, tutorials, hackathons
  * Customer feedback and iteration
 
## Phase 2

Create pricing tiers. Enable scaleup beyond base tiers. Drive sales.

- [M3O Platform Tier](platform.md) - Enable real production workloads on M3O
  * Secure, scalable and supported environment
  * Events, Logs, Metrics, Tracing aggregation
  * SLAs and support guarantees
- [M3O Team Tier](https://github.com/m3o/dev/issues/379) - Collaboration features
  * Shared namespaces
  * Per namespace quotas
  * SLAs
- M3O Cloud Tier - Isolated environments
  * Spinup of isolated environments
  * Scaleway, AWS, GCP, Azure
  * Multi-region deployments

## Phase 3

Provide value add beyond the platform. Enable customers to thrive based on their efforts.

- [Services](services.md) - Value add Micro services on the Micro platform
  * Free and paid services to consume
  * All services built in [m3o/services](https://github.com/m3o/services)
  * Comprehensive list of [services](services.md)
  * Leveraging existing APIs (Stripe, Twilio, etc)
  * Single API account for providers managed by Micro
- [Network](network.md) - A marketplace to buy, sell and share services
  * Ability to buy and sell services on the Micro platform
  * Transactional model: Percentage per request/service or flat 30%
  * Ability to run external "Resources" such as redis, postgres, etc
  
## Phase 4

Build a federate distributed model for Micro. Empower others to become Micro as a Service providers.

- License M3O distribution
  * M3O self-hosted as a service
  * Focus on small cloud providers
