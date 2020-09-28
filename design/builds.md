# Runtime Builds

## Introduction

This document outlines the flow of how the builds works in the runtime. There are a few new packages / interfaces which the runtime depends on to implement the build process, a summary of each is provided below:

• **Blob Store**: an interface used to write large objects (blobs) to a persistant store. It is used by the runtime to persist raw source code (as a .tar.gzip archive) and binaries. The local implementation is the file store, which uses bolt db internally. The platform implementation uses S3, configured to use Scaleway's object storage API.

• **Builder**: an interface which builds source code into binaries. There is one implementation for golang and also an RPC abstraction backed by m3o/services/build. The platform profile configures the runtime manager to use the RPC implementation by default, however if it detects it's running a service with the source github.com/m3o/services, it overrides this and uses the local golang implementation to prevent a circular dependancy.

## Flow

During this flow, i'll refer to the `micro run` example however the flow is almost identical for `micro update`, the only difference being the validation of a service's existance before executing the command against the runtime. 

• When a user executes `micro run [source]`, the runtime CLI package checks to see if the source is a reference to a Git remote or to a local directory (e.g. ./helloworld).

  • In the case of a git remote, the CLI validates the existance of the source. It does this by detecting the remote host (e.g. GitHub) and executing an API call. This logic hasn't been changed by the build process. The full address, e.g. github.com/micro/services/helloworld is passed as the source attribute of the service to runtime.Create.

  • In the case of local source, the runtime firstly figures out which directory to upload - if the directory passed by the user is within a git repo, it'll upload the entire repository and use the new "Entrypoint" create option to indicate which folder within the monorepo should be run. 

  Once the folder to upload and entrypoint has been determined, the CLI archives the source into a .tar.gzip. This source is then streamed to the runtime.Source.Upload endpoint. The runtime server writes this source to the blob store (within the users namespace) under a unique ID, e.g. "source://abc...". This key is then returned to the CLI which assigns it as the source attribute on the service. To prevent this value being displayed to the user on `micro status`, the orginal argument is added to the service's metadata under the "source" key, if this value is present when displaying the sevices, the CLI renders it instead of service.Source.

• The CLI now calls runtime.Create as it would have done previously, this executes an RPC to runtime.Runtime.Create, which in turn calls the runtime manager.

• The runtime manager validates the request and then checks to see if the builder was configured. 
  
  • If the profile has not got a builder configured, it starts by loading the source code. If the source was uploaded to the server (indicated by the "source://" prefix, it'll be pulled the blob store, otherwise the source is pulled from the Git remote). If the source is archived, it'll also be unarchived.

  Next, the runtime manager assigns the location of the raw source (a temp directory on the host) to the service's Source attribute and then call runtime.Create on the underlying runtime (e.g. the local runtime). If an error occurs, it's returned to the user. Finally, the manager writes the service to the store so it is returned by `micro status`.

  • In the other case where a builder is configured (such as when the platform profile is used), the runtime manager writes the service to the store with the status "Pending" and then perform the build asyncroniously, as outlined in the next section.

### The build process

• The service status is updated to "Building" and the source code is pulled in a similar fashion to the syncrinous flow. If the source is pulled from a Git remote, it's archived as the builder takes an io.Reader as the source (the type of archive used can be passed as an option).

• The builder then builds the source and return a binary. If an error occurs it's saved on the service and the build process ends here. The error is visible to the user when they run `micro status`. An error here is most likely a compile error such as a missing import.

• The manager uploads the build to the blob store under the name `build://name:version` in users namespace. If an error occurs at this stage, an Internal Server Error is reported to the user. 

• Finally, the status of the service is updated to Starting and the underlying runtime (e.g. kubernetes) is called. The kubernetes runtime creates the service and the deployment.

• The container starts and the "loader" script in the micro/cells:micro image streams the binary to the container using the runtime.Build.Read RPC. The build is then written directly to a file and then executed. The script uses the auth credentials injected by the runtime to authenticate on when pulling the build.

• The service is running. Because the service is now returned by the k8s runtime on runtime.Read, this status is now returned from the user when they run `micro status`.