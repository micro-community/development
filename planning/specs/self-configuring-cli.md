# Self Configuring CLI

The micro CLI is currently a fat client and has a lot of logic baked in. This will become an increasingly large problem as we start to build out m3o as there are many services / concepts which do not necessarily make sense in the OSS but are required for m3o. There is also the problem that the CLI is getting increasingly more unwieldy to work on and seems almost the opposite of the spirit of micro services.

To address these two issues we propose to move towards a model of a self configuring CLI. 
- We build and ship a minimal base CLI with the OSS commands only. 
- We introduce a new `micro init` command which will hit an endpoint on the platform and configure itself based on the response. This will add a bunch of new commands. This will have to be stored in ~/.micro/config
- Commands are then basically just RPC calls to a backend that will do the hardwork thus slimming down the CLI

For example, (currently) the email based OTP approach of `micro login --otp` is only supported on m3o and not the OSS. We don't want to bleed this in to the OSS if we don't have to. 

## Approaches 

### Self configured RPC calls 
The endpoint that the CLI hits returns a response which gives a list of RPC calls that can be made. Example response object
```
{
    "commands": [{
        "name" : "login",
        "description": "Login to the platform",
        "args" : [
            {"name":"email", "description": "the email address of the account", "proto_arg": "email"}
        ],
        "options" : {
            "otp" : {
                "description" : "Send an email with one time password",
                "type" : "bool",
                "proto_arg": "otp"
            },
            "password" : {
                "description" : "the password",
                "proto_arg": "password"
            }
        },
        "endpoint": "go.micro.login/Login"

    }]
}
```

Where
- `args` is an array of arg objects; as far as the CLI is concerned, arguments are positional so array order matters.
- `options` is a map of option objects which include type
- `proto_arg` tells the CLI which field in the proto request it maps too

In the first version we can have a simple service that, for a given env, returns the endpoints to be supported. It can be hardcoded (or config driven) but is not dynamic. In a later version it would be nice for services to be able to register these things dynamically although there is the potential for a very much larger and bloated CLI experience, say if every service decided to register some endpoints. 

This approach ensures lean CLI client with all the logic happening on the backend, which is the preferred model. However, a thin client approach would mean you couldn't have support for commands like `micro new` which can only do their work on the local machine. It's also means you can only do very simple mapping of args/options to a proto request - no complex nested structs, just field/value.

### Downloading plugin binaries

The endpoint that the CLI hits returns a list of URLs to binaries. The binaries are downloaded to ~/.micro/plugins. The binaries provide the additional functionality and are invoked by the based micro CLI binary with each binary representing a subcommand. For example a `login` plugin would provide `micro login` functionality. 

:question: Given that login is already a core function would we make otp login a separate subcommand like `micro otplogin`? If we make it an arg instead `micro login --otp` then the login plugin has to implement both basic auth login and otp login

So when you run `micro foobar` if the core CLI binary doesn't recognise the command it will search the plugins dir for the subcommand and run that if found. 

This approach allows us to continue having a rich/complex CLI experience with slightly fatter client code. 

We would need to ensure prebuilt binaries for all supported platforms. What happens when we don't have a prebuilt binary for that platform/arch? Perhaps a mechanism that downloads the code and does a go build on the user's machine for each sub command or have that as a fallback mechanism. MVP would be to just output instructions to download, build and place in the plugins dir.

