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

Flow interface

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
  // Execute specific flow and returns request id and error, optionally fills rsp in case of sync execution
  Execute(flow string, req interface{}, rsp interface{}, opts ...ExecuteOption) (string, error)
  // Resume specific paused flow execution by request id
  Resume(flow string, reqID string) error
  // Pause specific flow execution by request id
  Pause(flow string, reqID string) error
  // Abort specific flow execution by request id
  Abort(flow string, reqID string) error
  // Status show status specific flow execution by request id
  Status(flow string, reqID string) (Status, error)
  // Result get result of the flow step
  Result(flow string, reqID string, step *Step) ([]byte, error)
  // Stop executor and drain active workers
  Stop() error
}                                                                                                
```

step definition

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
  // Steps that are required for this step
  After []string
  // Steps for which this step required
  Before []string
  // Step operation to execute in case of error
  Fallback Operation
}                                                                                  
```

## Status

Incomplete. Lacks of timeout, retries. Dont have proper supports to pause/resume/stop/restart flow execution.
But its easy to add after minimal working code has been merged.


