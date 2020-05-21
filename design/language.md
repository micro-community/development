# Mu Language

The Mu language is an emergent language built for the era of services.

## Overview

Mu is a new language we're hypothesising about which is built on the foundations of services 
rather than any sort of formally defined spec. It is firstly not a replacement for any 
existing programming language such as Go, java, ruby, python, etc and does not attempt to be 
comparable to current programming models.

The goal is to lay the foundation for an emergent language where the keywords are 
services and all we attempt to do is define a grammar to associate these services 
in a cohesive way that then lets us perform actions at a higher level.

## Design

The assumption is that we can steal from the likes of bash while creating something 
purely human readable or with a fixed type set for interop between services. We 
should also include the ability to save new programs as the aggregate of many 
others but in lazy loaded fashion as with haskell execution.

```
# a service call to the store
# [service] [method] [input] [value]
> store write foo bar

# retrieve the output
> store read foo

# storing the output of such a command
> save result = store read foo

# evaluating the output
> exec result

# passing the output to an input
> input result into broker publish values
```
