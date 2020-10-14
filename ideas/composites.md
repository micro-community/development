# Composites

Composites are a way of chaining requests across multiple services

## Overview

The normal flow of programming in a microservices world starts by creating independent services which encapsulate domain boundaries. 
Overtime these boundaries bleed and direct synchronous requests are made to retrieve information across them. In a system thats 
well governed this is done as a set of orchestration services that encapsulate a higher level domain boundary. Often orchestration 
services are handwritten as a new service where it may make sense for this actually just to be a lightweight Composite that 
describes the relationship, flow and transformations.

## Design

A Composite is much like unix pipelining. There's no understanding of the data, there's no specific hard coded values or programs. 
Service calls are initiated with the responses sequentially piping one into the next. This is not GraphQL which spans independent 
services and morphs the data but actually taking the request from one service and pushing it through another until we have the 
expected result. This is a form of mapreduce.

## Implementation

TBD
