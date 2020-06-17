# Micro Development

The Micro development roadmap, team and contribution guide.

# Overview 

Micro is the fastest way to build, share and collaborate on services in the Cloud and beyond. Our goal is to continue on this mission in an open and collaborative way, both as a team and community. Up until now most of our ideas and development have revolved around discussions in [Slack](https://slack.micro.mu).

This repo serves as an open forum for collaboration, design docs and the roadmap.

## Contents

- [company](company) - collaboration, culture, growth, rules of engagement, vision
- [design](design) - where the design docs live
- [docs](docs) - for the public docs at dev.m3o.com
- [glossary](glossary.md) - a glossary of terms and explanation of brand, company, project, product
- [ideas](ideas) - a scratch space for new ideas and things in flux
- [issues](https://github.com/micro/development/issues) - where we track work
- [office hours](#office-hours) - times we are available to the community
- [philosophy](#philosophy) - how we design and work
- [roadmap](roadmap) - where the full roadmap lives
- [style guide](#style-guide) - coding style guide

## Roadmap

This is a high level overview for the open source. See the product [roadmap](roadmap).

- [X] consolidate all libraries into go-micro
- [X] gRPC API for the micro proxy
- [X] quic as a default transport
- [X] nats as a default broker
- [x] [gRPC](design/framework/grpc.md) integration and interop
- [x] embedded nats as the default broker
- [x] go, java, typescript, ruby, python [client](design/clients.md) libraries
- [x] standalone micro server
- [x] better documentation and end to end tutorials
- [ ] simpler kubernetes integration by default
- [ ] pluggable wrappers for go-micro itself
- [ ] dynamically defined cli, flags and env vars
- [ ] improved micro api configuration 
- [ ] graphql handler for the micro api
- [ ] wireguard support in the micro network
- [ ] reusable foundation [services](roadmap/services.md) 
- [ ] define the mucp [protocol](design/ideas/protocol.md)
- [ ] define the [mu](design/ideas/language.md) language
- [ ] implement the [wasm](https://github.com/bytecodealliance/wasm-micro-runtime) runtime

## Philosophy

Micro is the simplest way to build microservices. We have a developer first focus. Our goal is to make developers incredibly productive, 
to remove friction from their workflow and abstract away the complexities of distributed systems and cloud-native technology. 

Our approach to this is very clear. Any new project or any change that we make must come from a developer's perspective. 

Here's how we approach taking on new problems.

1. Engage the community about the problem and how we need to solve it.
	- Discussions lead to clarity in thinking
	- We can work through ideas before actually spending significant time writing code
	- We can understand if we're even solving a problem
1. Define the overall scope of the project and name it.
	-  e.g Auth, Config, Debug. This is the domain boundary
	- Go Micro deals with inter-service communication
	- Go Config deals with dynamic configuration
	- Micro API is an API gateway for HTTP requests
2. Start with a Go library/package, this is always our starting point, we want to solve for the developer in Go first. 
	- Define separate packages for sub-scopes of the domain
	- Start with the high level interface that will be used. Implement it and make it pluggable
3. Ship quickly and iterate, test the ideas with the community.
	- Go Micro was being used 2 weeks after the first line of code was written. It was called something else back then.
4. Encapsulate as a command/service in the Micro toolkit so that it solves the problem across all languages
	- Go Micro is at the core of all the toolkit components for discovery and inter-service communication
	- go-micro/api is the basis for the Micro api
	- go-micro/config will be turned into a dynamic config server with a gRPC or HTTP api
5. Everything that we do focuses on simplifying the experience for the developer
	- Provide a zero dependency default experience while being pluggable
	- Abstract away cloud-native and distributed systems. Operations is a separate concern
6. Build on our own foundations rather than those of others.
	- CNCF projects are complex, fast moving, breaking and we have no control over their long term goals
	- We want to own the foundations so we can build on them and focus on making developers productive
	- Where other tools solve complex problems we offload with plugins or abstract them away

## Contributing

- Open an [Issue](https://github.com/micro/development/issues) to start a discussion with the community
- Open a [Pull Request](https://github.com/micro/development/pulls) to add a design doc where you've already got strong ideas
- Help shape the roadmap for Micro and be a part of the microservice movement
- Take any real time conversations to the [#development](https://micro-services.slack.com/messages/CJ544CH8W/) channel on Slack

## Style Guide

The coding style guide is fairly straightforward.

- **KISS:** - Don't use complex algorithms where a for-loop would do. Just keep it simple. We'll fix perf later. 
- **Brevity:** - Don't use long variable names where a comment would suffice. Do the minimal work.
- **Consistency:** - See the surrounding packages, variables and types as a guide for how you write code.

## Workflow

When you are contributing whether it be bugs or features you are the owner of that through to completion.

The workflow is as follows:

- Discuss: Talk about the the bug or feature in #development with others first
- Document: Create an issue and todo note to track starting and progressing the task
- Deliver: Create a PR for your bug or feature and engage at least 2 other team members to review
- Verify: You should be testing throughout but once delivered its your responsibility to verify full functionality

## Office Hours

Office hours are times we are available to the community. This is an experimental feature we're testing. 

Fridays 2-5pm GMT we'll have an open call anyone can join to chat, ask questions, etc on [Discord](https://discord.gg/hbmJEct).
