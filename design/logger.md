# Logging

Micro need usable logger to be able to write messages about internal state and errors and also provide useful 
logger interface for end-user.

## Overview

Logger must provide minimal interface to write logs at specific levels with specific fields. Now blows up with many helper
funcs that all logger implementations needs to support.

## Implemenations

Now we have 4 implemntations:
* micro internal that writes to console and also to internal in-memory ring buffer
* zap
* logrus
* zerolog

## Design

Currently we have simple design

```go
type Logger interface {
    // Init initialises options
    Init(options ...Option) error
    // The Logger options
    Options() Options
    // Error set `error` field to be logged
    Error(err error) Logger
    // Fields set fields to always be logged
    Fields(fields map[string]interface{}) Logger
    // Log writes a log entry
    Log(level Level, v ...interface{})
    // Logf writes a formatted log entry
    Logf(level Level, format string, v ...interface{})
    // String returns the name of logger
    String() string
}
```

Also we have helper functions that automatic uses specified log-level:
* Warn/Warnf
* Error/Errorf
* Debug/Debugf
* Info/Infof
* Fatal/Fatalf
* Trace/Tracef

This is enought for internal micro usage. But after rethinking this is not so usable for end-user.
Most of the time user wants to create new logger with specific fields and write messages from it.
But not specify always log-level, and use helper functions (Warnf/Errorf etc).

## Proposed changes

Create in logger new function NewHelper with following signature:
```go

type Helper struct {
    Logger
}

func NewHelper(log Logger) *Helper {
    return &Helper{log: log}
}

func (h *Helper) Info(args...interface{}) {}
.....
```

## Benefits

We don't need to implemet such features in all loggers, but internally use only one method Logf
