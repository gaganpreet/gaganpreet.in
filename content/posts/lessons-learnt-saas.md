---
title: "Draft: What I learnt building a SaaS"
date: 2021-11-23T22:28:02+01:00
build:
  render: always
  list: false
---


It was around the start of the pandemic in 2020 that I started hacking away at some of the ideas that I had been collecting but hadn't had a chance to work on. I started building [No Cookie Analytics](https://nocookieanalytics.com/).


## Background

I had come across the [FingerprintJS](https://fingerprintjs.com/) project, and I had an idea to use similar fingerprints for a cookie-free analytics platform. It was a time when some of the other competitors in this market were still in infancy, however, I dreamt big and wanted to build a product that would include more information for marketers to base business decisions on.

Looking at the whole thing in retrospect, I wanted to record my experiences here for my future self and others who might find it useful.

### Good stuff:

- Open source
- Low code (eg: OpenAPI generator)
- 

### Work what you're familiar with


### Mistake #1: Picking up many new technologies
 
Any new project will involve learning some new skills. I wanted to pick up FastAPI as I had heard good things about the framework. So I picked up a boilerplate code for a FastAPI project. I was new to FastAPI and I was also new to Vue.js. I was now learning two new frameworks instead of using precious time to build an MVP and launch a product.

Using an existing boilerplate means that I was starting a project on an opinionated creation of someone else. In a way, that's yet another framework to wrap your head around. It took me a while to feel comfortable working with the codebase, something that should happen naturally from the beginning of your project.

**Lesson:** Work what you're familiar with.

### Mistake #2: Moving too slow/Waiting too long

With a full-time job, I didn't have a lot of time to work on No Cookie Analytics. For the first 6 months, I spent maybe a week working on it. Then I started working on it once a week. I was content to focus more on learning new things than building, The 6 months were already too much. It also felt like I hadn't gotten anything done, despite being aware of the fact that I hadn't been able to spend time on it.

Unfortunately, once a week is nowhere enough to build a project (coupled with #1) and it was only in March this year when I decided to quit my full-time job, that I could focus regularly.

**Lesson:** Find the shortest path to building an MVP (an MVP that doesn't suck) and follow it. Write a plan and don't stray from it.

### Mistake #3: Chasing perfection

While this is related to #2 it deserved its spot in this list. It's easy to fall into the trap of building a perfect experience. Decades of software development have brought us to a different conclusion: even the biggest products that we come across launched with bugs, and still have bugs that have not been fixed. This doesn't mean they are bad products. And this is one key lesson here: people are willing to put up with bugs, as long as the product lets them get stuff done.

**Lesson:** Building a perfect product isn't a realistic goal.

### Mistake #4 Not keeping up with market research

I knew of [Simple Analytics](simpleanalytics.com/) and [Fathom](https://usefathom.com/) when I started No Cookie Analytics. They were not as established as they are now. However, for anyone observing the privacy-friendly analytics market closely, there's now a lot of projects in the same space, many of them launching within the time it took for me to launch. I failed to keep with that.

**Lesson:** Do market research and keep informed on developments.

### Mistake #5 Missing a launch strategy

It's easy to build and not talk about the product. But without talking to people and finding out their problems is a trap: you may have the best goods, but if no one needs it or knows about it, you'll build a product for only one customer: yourself.

**Lesson:** Talk to potential customers, solve their problems.


## Summary

It took me a lot of self-reflection to write this post. As much as I love what I've created, I can't deny the fact that I'm launching a product in a market already saturated with many alternatives. So I'm taking a different path: write less code and talk instead. I hope it also helps others to learn from my lessons.
