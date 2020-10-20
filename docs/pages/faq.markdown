---
layout: default
title: FAQ
nav_order: 5
permalink: /faq
---

# FAQ
{: .no_toc }

## Account Recovery

Issue `micro signup --recover --email=youremail` which will email you instructions on how to log in to namespaces you have access to.
Currently there is no password recovery functionality, please contact us on Slack to do that.

## Billing Portal

To access your billing portal to adjust billing info or retrieve invoices run the following command to get your unique link.

```
micro billing portal
```

## Pricing

The Platform environment is priced at $35/user/month. We separately provide a free Dev environment which you can read about below.

## Additional Users

You can invite up to 5 additional users on the platform. Every additional user added to your account is billed at $35/month. 
Whether you invite them or just plain create the account we'll keep track and invoice this as "M3O Additonal Users" on your invoices. See 
[Get Started > Invite Users](/getting-started/invite-users) to see how to invite them.

## Additional Services

Beyond 10 services, we bill every additional service at $3/month. Additional service meaning anything with a new unique name
e.g users, customers, orders. We'll add a line item on your invoice called "M3O Additional Services" automatically.

## Changing Your Password

Use the following command to change password (you must already be logged in):

```
micro user set password
```

## Dev Environment

The Dev environment is a free tier hosted by us as a best effort service. It's a place for hobbyists and side projects. To get 
access please talk to #m3o-platform on [slack](https://slack.m3o.com). To login see the following.

```
# set the dev env
micro env set dev

# signup > use the credit card '4242 4242 4242 4242'
micro signup

# login
micro login 
```

The Dev env is also subject to fair usage. There are no SLAs or support. The quota is capped at 1 core and 1GB total resources.

## Fair Usage Policy

Our fair usage policy applies caps to usage on a per service and per namespace basis. This is so we can maintain a shared system 
for everyone to use in coordination and have a great experience. The limits are below but may change, vary or include new resource types.

Per service limits

- CPU - 1 core
- Memory - 128 mb
- Disk - 512 mb

## Cancellation

If you'd like to cancel your subscription please email [support@m3o.com](mailto:support@m3o.com).

## Support

If you're a paying customer you can join #m3o-support on [slack](https://slack.m3o.com) or email [support@m3o.com](mailto:support@m3o.com). Otherwise you can join #m3o-dev or #m3o-platform for general discussions around each environment.
