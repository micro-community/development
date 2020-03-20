# Flow

Flow is essential component for microservice mesh. It provides ability to utilize DAG to call endpoints in needed order. With flow component can be used in SAGA pattern to provide execute/roolback capabilities.

## Overview

Flow service must provide Flow manager that able to maipulate flows and steps inside it. And also Executor that runs workload in flow order. Most essential part, that we must provide not only static flow definition, but also provide ability to register some endpoint in flow after all services starts. So each service does not need to know about others.

## Implemenations

Now we have only one default flow implementation. It uses worker pool to distribute workload across workers. And some predefined operations, like:

* ClientCallOperation - calls service endpoint via micro client (rpc)

* ClientPublishOperation - call service endpoint via broker (pubsub)

* FlowExecuteOperation - call the same or another flow with specific step, 
  useful to able to rollback some failed action. FlowExecuteOperation utlize
  previous two operations to call endpoints

## Design

Flow interface modifies flow

```go
type Flow interface {
  // Init flow with options
  Init(...Option) error
  // Get flow options
  Options() Options
  // Create step in specific flow
  CreateStep(flow string, step *Step) error
  // Delete step from specific flow
  DeleteStep(flow string, step *Step) error
  // Replace step in specific flow
  ReplaceStep(flow string, oldstep *Step, newstep *Step) error
  // Lookup specific flow
  Lookup(flow string) ([]*Step, error)
  // Execute specific floa via Executor and returns request id and error, optionally fills rsp in case of sync execution
  Execute(flow string, req interface{}, rsp interface{}, opts ...ExecuteOption) (string, error)
}                                                                                                
```

Flow options
```go
type Options struct {
  // Executor used to execute steps in flow
  Executor Executor
  // Context is used for storing non default options
  Context context.Context
}
```

Executor interface provides steps execution 

```go
type Executor interface {
  // Init flow with options
  Init(...ExecutorOption) error
  // Get flow options
  Options() ExecutorOptions
	// Run execution with sync/async capability
	Execute(req interface{}, rsp interface{}, opts ...ExecuteOption) (string, error)
	// Resume specific flow execution by id
	Resume(flow string, id string) error
	// Pause specific flow execution by id
	Pause(flow string, id string) error
	// Abort specific flow execution by id
	Abort(flow string, id string) error
	// Status show status specific flow execution by request id
	Status(flow string, id string) (Status, error)
	// Result get result of the flow step
	Result(flow string, id string, step string) ([]byte, error)
	// Stop executor and drain active workers
	Stop() error
}
```

Executor options

```go
type ExecutorOptions struct {
  // Flow is used to be able to run another flow from current execution
  Flow Flow                                           
  // ErrorHandler is used for recovery panics
  ErrorHandler func(interface{})
  // Context is used for storing non default options
  Context context.Context
}
```

Step definition

```go
type Step struct {
  // name of step
  ID string
  // Retry count for step
  Retry int
  // Timeout for step
  Timeout int
  // Step operation to execute
  Operation Operation
  // Which step use as input
  Input string
  // Where to place output
  Output string
  // Steps IDs that runs after this step
  After []string
  // Steps IDs that runs before this step
  Before []string
  // Step operation to execute in case of error
  Fallback Operation
}                                                                                  
```

Operation definition

```go
type Operation interface {
  Name() string
  String() string
  Type() string
  New() Operation
  Decode(*pb.Operation)
  Encode() *pb.Operation
  Execute(context.Context, []byte, ...ExecuteOption) ([]byte, error)
  Options() OperationOptions
}
```

Execute options

```go
type ExecuteOptions struct {
  // Passed flow name
  Flow string
  // Passed execution id                                                      
  ID strinh
  // Passed step to start from
  Step string
  // Step ID to store Output data
  Output string
  // Timeout for currenct execution
  Timeout time.Duration
  // Async execution run, dont wait for complete
  Async bool
  // Concurrency specify count of workers create for steps in flow
  Concurrency int
  // Retries specify count of retries for each step in execution
  Retries int
  // Client for communication
  Client client.Client
  // Context is used for storing non default options
  Context context.Context
}
```

Operation options

```go
type OperationOptions struct {
  Timeout   time.Duration
  Retries   int
  AllowFail bool
  Context   context.Context
}
```

Step statuses

```go

type Status int

const (                       
  StatusUnknown Status = iota
  StatusPending
  StatusFailure
  StatusSuccess
  StatusPaused
  StatusAborted
  StatusStopped
)                             

```

## Status

Incomplete. Lacks of timeout, retries. Dont have proper supports to pause/resume/stop/restart flow execution.
But its easy to add after minimal working code has been merged.


