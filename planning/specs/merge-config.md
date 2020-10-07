# Merge Config

Currently the config values are saved "as is" ie. `micro config set key '{"hi":5}'` will end up as a string.
This is rather inconvenient.

This document proposes that objects `set` will be merged with existing objects.
In case someone wants to overwrite a previous object they an issue a `del` first.

Only problematic thing here is that since `--secret` values are represented as an option, batch setting secret and non secret values must happen in two different calls.

## Design

TODO
