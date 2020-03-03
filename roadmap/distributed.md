# Distributed

**Distributed** is a collaboration tool for distributed teams and the first product we're building on the platform.

## Overview

Our goal is to dogfood our own product through and through. To do this we need to build products on the 
platform. Because our team is going fully distributed we'll ultimately need collaboration tools to enable 
that experience. Right now we have a disparate set of tools to do this. 

**Distributed** is a collaboration tool for distributed teams powered by Micro.

## Features

The Distributed service includes the following features:

- Sprint planning (dealing with non verbal queues and allowing people to speak)
- Live streaming (video and audio)
- Messaging, comments and threads
- Interactive Whiteboard with history
- TODO, notes, reminder sharing/tracking
- Screen sharing
- ... more to come

## Design

Distributed is designs as a Micro services product with services themselves defined by their domain boundaries.

- Streaming
- Messaging
- Reminders
- ...

Distributed is built on the M3O platform

## Sprint Planning

Sprint planning is a massive pain point in a distributed team. Especially where people are in the room and on a conference call. 
Trying to speak when someone else is speaking is difficult without non verbal queues. This is really a planning or 
design discussion oriented thing rather than a conference call itself. Unclear if its more generic than that but it's 
specifically for this purpose.

Features

- Simple collaborative realtime planning
- Non verbal queues for when someone wants to speak
- Potential notes / messages / comments to be read inline

