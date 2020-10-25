# Licensing

This document defines Micro licensing in relation to our open source software, company related software and products.

## Overview

Micro was originally Apache 2.0 Licensed but as we move to v3 and offering a hosted service we've moved to using 
[Polyform Shield](https://polyformproject.org/licenses/shield/1.0.0/). The reason for using Polyform Shield is to 
prevent AWS and other cloud providers from hosting Micro as a Service without contributing anything back. This may 
be controversial to some and so it's important that before joining the company people understand this is how we 
operate and why.

## Rationale

AWS has made a business from taking popular open source projects used by their customers and hosting them as a managed 
offering. This is primarily for the benefit of their customers and so that they can reap a profit from a higher margin 
service rather than users just paying for the compute and running the open source software themselves. In principle 
this makes a lot of sense as AWS wants to better serve their customer, in practice what you see is no value is returned 
to the authors of the software. In most of these cases they've done all the R&D, spent millions in funding, built teams 
of maintainers and their own product, yet AWS deems it fit to pick up the software and run it, without even so much 
as a conversation.

If a project is liberally licensed, legally there is no issue, but ethically this is down right wrong and immoral. 
As a commercial open source software company we cannot be naive, and I will fundamentally not allow AWS and others 
take advantage of me, our team or this company. For this reason we take a forward looking view and use Polyform Shield 
as our license for Micro now. We anticipate what's to come and we standby our counterparts in the industry that have 
sufferred at the hands of AWs.

## Polyform Licence

Micro is licensed as Polyform Shield. Polyform and related licenses were written by Heather Meeker and her colleagues. 
Heather Meeker has drafted the majority of the new commercial open source licenses and has a history in open source 
that spans far beyond most. It's for that reason and a personal conversations with her that has given us confidence 
to make use of this license. 

Commercial licenses were largely custom drafted at a large expense previously. As commercial open source software 
becomes a stronger component in the industry, licensing standardisation must emerge and Polyform is the best bet 
for that.

## Server License

The Micro server license is Polyform Shield. This enables the use of the software much like Apache 2.0 but with one 
caveat, you cannot offer Micro as a Service and you cannot compete with any related M3O services which we provide. 
We anticipate that in time we will perform some form of dual licensing to allow others to become Micro as a Service 
providers but this will be a future effort in relation to and including M3O services.

## M3O Services

M3O Services which exist in (github.com/m3o/services) are company related services used to power the M3O Platform. 
These are strictly licensed using [Polyform Strict](https://polyformproject.org/licenses/strict/1.0.0/). The reason 
is because we want to offer M3O as a dual licensed offering to smaller cloud providers in the future so they can 
also run Micro as a Service. This is a business decision and future product, hence strict licensing. This 
"source available" model is the same as basically having private repos.

## Micro Services

Micro services in (github.com/micro/services) are reusable services which can be used in a noncommercial fashion 
e.g they can be used for personal use, non-profits, etc but no commercialisation. In time we may change this but 
for now they serve as example services and for future local use.

## User Code and Clients

Users will more than likely want more liberal license use within their software. Having to think about the licensing requirements 
beyond MIT or Apache 2.0 in your own source code can be quite problematic and so for this reason the split is always deemed as 
Server being strictly licensed while clients are liberally licensed using Apache 2.0.

As we've gone through a v3 refactor, this is something we've just pushed to the side. Polyform Shield is in fact a very liberal 
license with the one stipulation, you cannot offer Micro as a Service and you cannot compete with any future offerings we provide 
on top of that. Many will adopt it without issue, but we also want to promote an open ecosystem in the sense that users should 
be free to write whatever they want while leveraging micro. So we'll look to license clients in separate repos as Apache 2.0

## Other Software

We have other examples and related software. For all intents and purposes, we will always start with the use of 
[Polyform Strict](https://polyformproject.org/licenses/strict/1.0.0/) until there's a better understanding of how it should be 
licensed. For this reason m3o/services, micro/services and mostly anything not micro is under the Polyform Strict license.

## Future Licensing

When in doubt make use of Polyform Strict and then start a conversation with the relevant parties about licensing. It's a business 
decision rather than a technical one and should be treated as so. The same goes for which cloud providers we choose to use. 
If you want to understand more about that ask Asim Aslam first.

## References

The list of references

- [Polyform Project Licenses](https://polyformproject.org/)
- [CockroachDB: Why we're relicensing](https://www.cockroachlabs.com/blog/oss-relicensing-cockroachdb/)
- [Redis Labs: Source available licencing](https://techcrunch.com/2019/02/21/redis-labs-changes-its-open-source-license-again/)
- [MongoDB: SSPL Licensing FAQ](https://www.mongodb.com/licensing/server-side-public-license/faq)
- [Confluent Platform: Community License](https://www.confluent.io/blog/license-changes-confluent-platform/)
- [War with AWS and liberal licensing](https://techcrunch.com/2019/05/30/lack-of-leadership-in-open-source-results-in-source-available-licenses/)
