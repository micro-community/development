# Backend

Backend is [Backend as a Service](https://www.cloudflare.com/learning/serverless/glossary/backend-as-a-service-baas/).

## Overview

Backend provides Backend as a Service for frontend developers. It's focused on giving devs the ability to build 
applications without having to worry about infrastructure. While M3O provides Micro as a Service for those 
who want to build Micro services, Backend goes a step further to focus on the frontend developers needs.

## Features

- Database storage
- File storage
- User authentication
- Push notifications
- Geolocation
- Email marketing
- ...

## API

Backend provides a standard http/json API via `api.micro.mu/backend` and web ui at `web.micro.mu/backend` to be 
later hosted at `backend.micro.mu`. We may in future support other query mechanisms.

The API will then be used for the basis of an npm backend by the same name at @microhq/backend
