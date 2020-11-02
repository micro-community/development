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

## Example of using secrets

Given that the `Config` instance has access to an encoding key (likely an option called `SecretKey`) secrets can be used in the following way:

```
# the value saved here will be encrypted at rest
config.Set("path.to.secret", "Very Secret Value!", config.Secret(true))

# getting the value out
config.Get("path.to.secret", config.Secret(true))
```

## Handling encryption keys

### Proposal 1

Keep it simple. Have one key to encrypt all secret values across all namespaces.

### Proposal 2

Create a different random generated encryption key per namespace and store these keys encrypted in the store.
This is so if users manage to get the key with brute force (they might save a simple value and try keys over and over to get back that value since they know the encryption due to open source)
they still won't have the key to everyone else's namespace.