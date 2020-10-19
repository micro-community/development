# Lint

Add `micro lint [path]` as a CLI command to format services and ensure all micro services are uniformed. The command would run against the directory at the given path or default to the working directory. If a .mu file is not present, one will be generated. It will also print out warnings if folders such as "proto" and "handler" are missing. 

Over time we can add more checks as best practices for developing micro services emerge.