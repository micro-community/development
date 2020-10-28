# Local Source Upload

This spec defines the design for running local source on the micro server

## Overview

Micro supports running public and private github repos along with local source code however in the case 
of local source, it only works with the "local" profile, meaning code is uploaded to the server and 
stored in a temporary directory. This design looks to move to a new RPC endpoint in the runtime 
for source upload and storage in a blob store.

## Design

Note: with a build service this flow may change

Local source upload will function in the following way:

1. `micro run .` packages the local source code as a tarball and streams it to the runtime service
2. The runtime service stores the tarball using a blob store interface (honouring multi-tenancy isolation of user code)
3. The micro runtime cell uses a `micro source download` command which pulls source through the runtime and runs it

```
    # Uploading source
    Dev (Local) ===> Micro (Runtime) ===> Store/Blob ===> File / S3 Object Storage

    # Downloading source
    File / S3 Object Storage <==== Micro (runtime) <==== Cell (Micro)

```

## Technical

### Source Endpoint

The runtime will need a new Source proto interface with methods Upload/Download

```
service Source {
    rpc Upload(UploadRequest) returns (stream Data) {};
    rpc Download(DownloadRequest) returns (stream Data) {};
}
```

Sample code can be found here https://github.com/micro/micro/pull/1276/files#diff-9bf87d75cf636b7b0789f3851ada9776R6

### Blob store interface

The runtime will need to store the source code so that 1. it's persisted beyond the dev local env and so that it can 
be pulled from within the container or independent instances of the runtime where its on a dev local or baremetal 
or wherever else.

```
# package go-micro/store

type Blob interface {
    Read(bucket, key string) (io.ReadCloser, error)
    Write(bucket, key string) (io.WriteCloser, error)
    String() string
}
```

### Technical flow

1. `micro run .` calls runtime.Source.Upload and streams the source to the runtime
2. The runtime service uploads the code to the blob store (whether it be written as a file or into object storage)
3. When run locally the runtime executed a Cell struct that knows to stream from the blob store
4. When run on kubernetes the runtime cell pulls the source from the runtime and execs it

## Caveats

We are potentially moving towards the use of a build service so the flow would be augmented to pass the code 
to the build service to be built. The runtime should only know about a Build interface, so this is less 
of an issue in the case of on the fly local builds but something to be aware of.

