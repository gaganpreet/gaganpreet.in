---
title: "I Don't Get Microservices"
date: 2025-11-23T14:03:52+01:00
---

A lot has been written about microservices and I simply wanted to add some more.

We've been expanding the team at DigiUsher. As a result, I've interviewed dozens of engineers. I noticed a pattern: almost everyone defaults to microservices architecture, even those who've only worked at smaller scale. When I ask why, the answers are often vague. In my experience, many engineers often don't understand how complicated it is to deploy code AND keep everything functioning.

Here's what I have learned in my working career: I have yet to see a microservice architecture that doesn't carry significant unnecessary complexity compared to a well-built monolith.

### The Complexity Tax

With microservices, you're always playing Lego with distributed systems concerns:

- Shared databases or multiple databases with consistency challenges
- Internal API calls and their failure modes
- Ensuring data types across various services match or deal with gRPC
- Message queues and eventual consistency
- Service discovery and network reliability
- Distributed tracing and debugging

The codebase becomes more complex. The deployment pipeline becomes more complex. The monitoring and observability needs multiply. The engineering team needs more resources - both human and machine. Yes, you might pitch Kubernetes as a solution, but now you're adding another layer of operational complexity on top of an already complex architecture.

A monolith, on the other hand: a single application, one or two databases, straightforward deployment. Note that a monolith doesn't mean a single app instance - you can still scale it horizontally. Further, each instance can have different responsibilities, only the invocation changes.

### Monoliths Scale Further Than You Think

I've worked on products that scaled to tens of millions of users with a single monolithic application and database. Did we break a sweat? Not really. Deploys were straightforward. When we needed to migrate from Heroku to AWS, the process was manageable even with that userbase. Try doing that with a distributed microservices architecture.

### When Microservices Make Sense

Microservices have their place. Genuinely independent business domains, very different scaling characteristics for different parts of your system, or truly separate teams that need to move independently. At a startup scale, that's never the problem.

You'll be fine with a monolith at the scale of even a million users. Even well beyond that. The complexity of microservices is earned, not required by default.

Build a simple monolith. Scale it vertically and horizontally. Add read replicas. Use caching intelligently. You'd be amazed how far you can go and how fast you can move.

(Note: Claude was used to proofread)
