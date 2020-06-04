# Build

Build is the micro build service currently powered by GitHub Actions

## Overview

Our goal is to have deterministic builds and a scorchingly fast build pipeline that makes 
source to running possible in less than 30 seconds. Ambitious goal we will hit. The 
build pipeline currently operates using GitHub Actions at the core.

## Design

Requirements

- Deterministic builds
- Ability to specify per service unique requirements
- Building Go and beyond
- Generating protos
- ...
