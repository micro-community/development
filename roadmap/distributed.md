# Distributed

**Distributed** is a collaboration tool for distributed teams and the first product we're building on the platform.

## Overview

Our goal is to dogfood our own product through and through. To do this we need to build products on the 
platform. Because our team is going fully distributed we'll ultimately need collaboration tools to enable 
that experience. Right now we have a disparate set of tools to do this. 

**Distributed** is a collaboration tool for distributed teams powered by Micro.

## Features

The Distributed service includes the following features:

- Sprint planning - notes, issue tracking, discussion (dealing with non verbal queues and allowing people to speak)
- [OKRs](https://en.wikipedia.org/wiki/OKR) (objective and key results)
- Time tracking (aka when your team overlaps with you for synchronous work)
- Live streaming (webRTC)
- Video and audio clips (whatsapp style)
- Messaging, comments and threads
- Interactive Whiteboard with history
- TODO, notes, reminder sharing/tracking
- Screen sharing
- ... more to come

## Design

Distributed is designs as a Micro services product with services themselves defined by their domain boundaries.

- Streaming ([webRTC](https://webrtc.org/) or https://github.com/pion/webrtc)
- Messaging 
- Reminders
- Notes

## MVP

The MVP starts with note taking but will focus on sprint planning as the first problem to solve.

- Define a Sprint
- Define issues in a sprint
- Attach notes and comments
- Discussion during planning

## Sprint Planning

Sprint planning is a massive pain point in a distributed team. Especially where people are in the room and on a conference call. 
Trying to speak when someone else is speaking is difficult without non verbal queues. This is really a planning or 
design discussion oriented thing rather than a conference call itself. Unclear if its more generic than that but it's 
specifically for this purpose.

Features

- Simple collaborative realtime planning
- Non verbal queues for when someone wants to speak
- Potential notes / messages / comments to be read inline

## Compensating for the lack of non verbal cues

We could compensate for the lack of non verbal cues for example when one wants to speak up with ephemeral emojis.
Like how in school pupils put their hands up to talk, an "I want to speak" emoji could appear on the screen next 
to the person issuing it and it could slowly disappear.

The ephemeral nature would enable both the spamming of the given emoji which is playful, but also gives a visual 
cue to when it was issued (ie. older emojis would be more faded/in an other position etc.)
