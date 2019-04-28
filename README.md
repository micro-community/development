# Development

This is the Micro development roadmap.

# Overview 

Micro is the simplest way to build microservices. Our goal is to continue on this mission in an open and collaborative way 
with the community. Up until now most of our ideas and development have revolved around discussions in [Slack](https://micro.mu/slack/). 
This useful for realtime collaboration so we can move quickly but often means not everyone gets to contribute or we don't 
have a history for others to go back and look at to understand how we got to where we are.

This repo serves as an open forum for long term design ideas, collaboration and ultimately the roadmap for Micro.

## Roadmap

This is a rough plan but we'll provide something more detailed soon

- gRPC API for the micro proxy
- go, java, typescript, ruby, python client libraries
- better documentation and end to end tutorials
- simpler kubernetes integration by default
- pluggable wrappers for go-micro itself
- more flexible options dynamically defined as flags and env vars
- vault support for go-config
- improved micro api configuration 

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
2. Start with a Go library, this is always our starting point, we want to solve for the developer in Go first. 
	- Define separate packages in the Go library for sub-scopes of the domain
	- Start with the interfaces that can then be implemented and be made pluggable
3. Ship quickly and iterate, test the ideas with the community.
	- Go Micro was being used 2 weeks after the first line of code was written. It was called something else back then.
4. Encapsulate as a command/service in the Micro toolkit so that it solves the problem across all languages
	- Go Micro is at the core of all the toolkit components for discovery and inter-service communication
	- Go API is the basis for the Micro api
	- Go Config will be turned into a dynamic config server with a gRPC or HTTP api
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
