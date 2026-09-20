---
title: "Tracing a mysterious GitHub webhook"
date: 2026-09-20T14:13:20+02:00
---

A little while ago, as I was wrapping up my day, I discovered an active webhook configured in the digiusher code repository. Events including PRs, issues, and commits were being sent to this webhook. I make it a habit to sweep our authorized apps on GitHub occasionally but I had never paid attention to webhooks for some reason. It didn't help that this webhook was configured not at the organization level but on an individual repository.

## Investigation

The payload URL of the webhook was simply this:

```
https://github-bot-production.appspot.com/webhookEvent/_ID_
```

The problem was -- I didn't remember setting this up. I disabled the webhook right away, but then immediately went into detective mode because I was quite curious how the webhook got there in the first place. Seeing as no one else in our organization had admin access to the repository - it could only have been me, but am I getting far along in my years?

### Dead end 1 - Domain research

The only information I had about the webhook was the domain: `github-bot-production.appspot.com`. Anyone can deploy an app on App Engine and receive a subdomain on appspot.com. As I expected, `dig`ging the domain or any other domain level investigation didn't lead anywhere.

#### Dead end 2 - Google

I searched around - no results on Google or any other search engine for `github-bot-production.appspot.com`.

### Dead end 3 - GitHub

I started to play around with the GitHub CLI if that would turn up anything else. The JSON response contained only one useful additional piece of information, when the webhook was created - in February 2025, about 1.5 years ago - and only thing I remember was that I was visiting my family in India at that time.

### Audit log

Although the webhook was added over a year ago and the GitHub audit log doesn't extend that far back. However, the audit log had an event as a result of a recent webhook update

```
{
  "@timestamp": 1778942223026,
  "action": "hook.events_changed",
  "actor": "gaganpreet",
  "actor_id": 815873,
  "oauth_application_id": 659568,
  "actor_is_bot": false,
  "actor_location": { "country_code": "US" },
  "user_agent": "Apache-HttpClient/UNAVAILABLE (Java)"
}
```

There are three interesting fields - `actor`, `actor_location` and `oauth_application_id`. My GitHub user id had changed something in the webhook just a few weeks prior from the US. But I wasn't in the US at the timestamp.

The third one was the last clue I needed - the OAuth application ID led me to the "OAuth App Policy" in GitHub (which is defined at the organization level, not the repository level like the webhook), which pointed to "Google Chat". And then it all added up - one and a half years ago, I had linked Google Chat to our repo to send alerts to Google Chat on repo events.

## Naming disaster

This is a terrible naming disaster by Google. `appspot.com` tells me that the application is running on Google infrastructure, but it tells me nothing about who actually operates the application behind that subdomain. Google -- please fix it -- you have the whole `.google` tld, the least you could do is use a domain like `https://github-webhook.google` instead of an appspot subdomain.

GitHub also has room for improvement here. The webhook UI gave me no indication of the origin of the webhook and if it was created by a user or managed by an OAuth application. The only reason I found the connection was an audit log event containing `oauth_application_id` from a recent update that Google pushed to the webhook. Audit log isn't even available for free plan and without that I'd never have found out the link between the webhook and the OAuth app responsible.

In any case, if you land here on this page after searching for `github-bot-production.appspot.com`, hopefully this saves you the same investigation that this service belongs to Google.

(AI was not used to write this post other than spell and grammar checks).
