# Mobile

Mobile is an android and iOS experience for Micro

## Overview

Mobile has often been left behind when it comes to developer experience and its often the last thing 
that's thought about. When building products mobile first is really now the expectation and Micro 
needs to drive that forward for developers also. Micro Mobile will provide a mobile view and point 
of access for all Micro Services.

Mobile will exist in github.com/micro/mobile

## Design

We will use [Flutter](https://flutter.dev/) as our mobile framework which will cross compile for 
iOS and Android. Where possible we will load widgets/profiles defined in a [service]/mobile directory 
so that any service can be dynamically added on the fly. Mobile will operate much like Micro Web, 
a skeleton and home screen.
