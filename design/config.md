# New config interface

## Problem

We decided to rewrite config from scratch due to complexities around implementation and also to enable `Options` for `Get` `Set` etc with a new interface.

## Old Interface

```go
// Reader is an interface for merging changesets
type Reader interface {
	Merge(...*source.ChangeSet) (*source.ChangeSet, error)
	Values(*source.ChangeSet) (Values, error)
	String() string
}

// Config is an interface abstraction for dynamic configuration
type Config interface {
	// provide the reader.Values interface
	reader.Values
	// Init the config
	Init(opts ...Option) error
	// Options in the config
	Options() Options
	// Stop the config loader/watcher
	Close() error
	// Load config sources
	Load(source ...source.Source) error
	// Force a source changeset sync
	Sync() error
	// Watch a value for changes
	Watch(path ...string) (Watcher, error)
}
```

## New interface

```go
// Config is an interface abstraction for dynamic configuration
type Values interface {
	Get(path string, opt ...Option) Value
	Set(path string, val interface{}, opt ...Option)
	Delete(path string, opt ...Option)
}

type Config interface {
	Values
	// Init the config
	Init(opts ...Option) error
}
```

## Changes

- Removed all config implementations (file/memory etc), now we only have 1 very light implementation which uses the `Store` interface
- Removed `Source`, `Loader`, `Watcher`, `ChangeSet` (auditing) concepts entirely
- `Values` interface now supports options (needed for secrets and for a `Key` option which will drive namespacing now that store interaction is pushed into the config implementation, this previously happened in the config server handler)
- Config service interface `Read` etc endpoints were renamed to match `Get` `Set`terminology