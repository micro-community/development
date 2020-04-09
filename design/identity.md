# Identity

This is the design doc for service identity

## Overview

Service identity is at the core of our runtime. Every service has a given name, but an identity is verifiable 
and can be traced to the root of the creator of that service. We propose to create an identity system that 
is bootstrapped from the ground up based on public/private keypair and verified by the runtime and auth services.

## Design

To be done by Team

## Ideas

1. User: Calls `micro run helloworld` - they are the root of the identity
2. Runtime: Starts the service on a given pod with a given address
3. Service: Generates a csr and public/private key pair based on its name/address
4. Auth: Verifies the certificate signing request from the service via the runtime
5. Account: Service now has a verified account which can be used
