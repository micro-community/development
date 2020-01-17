# Plugins

Micro is a pluggable architecture via the use of Go interfaces.

## Overview

In v2 we plan to streamline how plugins are loaded and used. Rather than specifying a number of core defaults 
all plugins will move to github.com/micro/go-plugins and we'll look to provide a better developer experience 
for loading these at build or runtime.

## Design

Our goal will be to generate a `plugins.go` file in top level main package. This will be generated 
via the use of the `--plugins` flag when calling `micro {new, build, run}`. Each command serves a 
purpose of generating a template, building the service or running it. They'll check for 
the plugins file and regen as necessary.

```
micro run service --plugins=broker/rabbitmq ./...
```
