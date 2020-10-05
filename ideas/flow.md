## Flow Service

The flow service is a workflow orchestration engine

## Overview

After CRUD services are written for each domain, we effectively end up writing orchestration services that execute RPC calls 
across these services and fire events. They deal with a flow like signup or cancellation. This is complex and sequentially. 
E.g signup requires the subscription to be created otherwise you end up with an account that has access that's not making 
payments. Doing this async can't be tolerated but handcrafting each of these services to deal with the complex failure 
scenarios doesn't make sense, its 100s of lines of boilerplate common code. The same for crud but thats a separate story.

## Design

A Flow represents a workflow or a state machine, a sequential set of steps to be executed one after the other and any 
rollback step to be taken in the even of a failure. It includes the ability to define retries, events to publish, etc. 
Every step is created as an event so that there are a stream of events that can be replayed if ever needed and 
the ability to view the active state and history of the entire system.

A flow is as follows

```
// Flow represents a workflow
type Flow interface {
	// Unique ID or Name of the flow
	ID() string
	// Register a step in the flow
	Register(Step) error
	// Execute the flow
	Execute() (Result, error)
	// Stop the flow at any point
	Abort() error
	// Retrieve the current status
	Status() (Status, error)
	// Retreive the steps
	Steps() ([]*Step, error)
}

type Step struct {
	ID string
	Exec func() error
	Rollback() func() error
}

// a predefined RPC step
func NewRPC(service, endpoint string, request interface{}, ...StepOption) *Step

// a predefined event subscription which acts based on an event
func NewEvent(topic, event string, *Step) *Step
```

## Usage

A flow would be defined for a complex sequence such as signup, cancellation, billing reconciliation, etc. The flow is defined 
as a sequence of steps that may make RPC calls or act on events that its waiting on.

```
signup := flow.New(
	flow.ID("signup"),
	flow.Steps(
		flow.NewRPC("customers", "Customer.Create", ...),
		flow.NewRPC("subscriptions", "Subscription.Create", ...),
		...
	)
)

res, err := signup.Execute()
```

## Service

A flow service would provide an orchestration engine which can map flows defined as json into a sequence which is executed based 
on an RPC, an event or a schedule. The flow service allows complex flows to be stored in a single location so that business 
processes are well defined and understood.

The Flow service is largely CRUD but also provides a "Provider" interface used by services that want to exec callbacks or 
participate in a flow, this mimics the Uber DOMA architecture pattern.
