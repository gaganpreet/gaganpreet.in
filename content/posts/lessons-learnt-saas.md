---
title: "What I learnt building a SaaS"
date: 2021-11-29T22:26:02+01:00
---


## Background

It was around the start of the pandemic in 2020 that I started hacking away at some of the ideas that I had collected but didn't have a chance to work on. I had come across the FingerprintJS project, and I had an idea to use similar fingerprints for a cookie-free analytics platform. At that time, other competitors in this market were still in their infancy, and I wanted to build an analytics product that will have more information for marketeers to base business decisions on. I started building [No Cookie Analytics](https://nocookieanalytics.com/).

It is now a pretty well-polished product ([demo](nocookieanalytics.com/nocookieanalytics.com)) with a powerful dashboard and an extensive API and is open source, but there are things that I realised could have been done better in retrospect. I want to share my experiences here with others who might find them useful.


### Lesson 1: Build what you're familiar with

Any new project will involve learning new skills. I wanted to pick up FastAPI, so I used a boilerplate code for a FastAPI + Vue.js project. I was now learning two new frameworks, FastAPI and Vue.js, instead of using my time to build an MVP and launch a working product. 

Using an existing boilerplate also implies that I was starting a project on an opinionated creation of someone else. In a way, that's yet another framework to wrap my head around. It took me a while to feel comfortable working with the codebase, something that should happen naturally from the beginning of the project. This did inspire me to create a [low-code personal starter boilerplate](https://github.com/gaganpreet/fastapi-starter) for future projects.

### Lesson 2: Embrace simplicity

It's good to dream big, but an MVP should be exactly the opposite of that. I kept my production setup free of complexity. A simple script is enough to pull in new changes and update the images running in Docker Swarm.

I was also not confident about open-sourcing the project from the get-go, however, once I did that, it simplified my workflow a lot more as my Docker Swarm setup didn't have to deal with credentials for fetching Docker images any longer.

### Lesson 3: Write a plan to build an MVP (and try not to stray from it)

It took me a while to find a rhythm. Since I had picked up new technologies to learn, I was content with learning and not building. For the first 6 months, I spent very little time working on the product, and then I scheduled a day of the weekend that I could work on it. This was not enough commitment. Unfortunately, once a week is nowhere enough to build a project and it was only in March this year when I quit my full-time job that I could focus regularly.

### Lesson 4: Building a perfect product isn't a realistic goal

It's easy to fall into the trap of building a perfect experience. I spent a whole week [improving the page load speed](https://gaganpreet.in/posts/vue-vuetify-performance/) when I could have stopped at the low-hanging fruits. I also spent an inordinate amount of time optimising my CI build process: something which wasn't even required.

Decades of software development have brought us to a different conclusion. Even the biggest products that exist today launched with bugs, and still have bugs that have not been fixed. This doesn't mean they are bad products. And this is the key lesson here: people are willing to put up with bugs, as long as the product lets them get stuff done.

### Lesson 5: Do market research and keep informed on developments

I knew of [Simple Analytics](simpleanalytics.com/) and [Fathom](https://usefathom.com/) when I started [No Cookie Analytics](https://nocookieanalytics.com/). They were not as established as they are now. For anyone observing the privacy-friendly analytics market closely, there are now a lot of projects in the same space, many of them launching within the time it took for me to launch.

### Lesson 6: Talk to potential customers

It's easy to build and not talk about the product. Not talking to people and finding out their problems is a trap: you may have the best product, but if no one needs it or knows about it, you'll build for only one customer: yourself.

## Summary

It took me a lot of self-reflection to write this post. As much as I'm proud of what I've created, I can't deny the fact that I'm launching a product in a market already saturated with alternatives. So I'm taking a different path: talk instead of writing code and get people interested in the product. I also hope it helps others to learn from my learnings.

You can sign up for [No Cookie Analytics here](https://nocookieanalytics.com/).
