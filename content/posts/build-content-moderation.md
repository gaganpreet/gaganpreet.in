---
title: "No escorts allowed: How I fought spammers"
date: 2021-10-18T16:28:37+02:00
images:
    - /images/2021/fence.jpg
typora-root-url: ../../static
---

Warning: This post features text that might not be safe for work.

## Background

Incorporating anti-spam measures are the least of concerns while building a user generated content (UGC) platform. Unless you're paranoid and spend precious time building moderation features in your platform, there will come a day when you sorely miss those tools. This is a story about exactly how this happened and how I dealt with it at Polarsteps.


## Spam content

There's more than one kinds of spam, but the kind of spam I focussed on was accounts advertising their "call girl" or "escort" services:

![Spam content](/images/2021/spam.jpg)

Within a few weeks the website was swarmed with spam accounts for "call girls", "escorts", linking to their website and/or phone number. That's the key feature of these spam accounts: they are driving traffic to their own sources.


## What won't work

Wait and watch and maybe the problem goes away? Once the floodgates are open the spammers will keep pouring in.

Banning the spam accounts in one go with some hurriedly written SQL queries? No dice, these are professional spammers and they just make new accounts.

Using Recaptcha to slow them down? Maybe it helps if spammers are creating hundreds of accounts a second, this was a steady pace of few accounts an hour and a CAPTCHA poses no hurdle for them.

Conclusion: This isn't a problem suitable for a quick and dirty solution. It was time to roll up the sleeves and get down to building a spam pipeline.


## Step 1: Build moderation features and a rudimentary pipeline to handle spammers

Before I did anything, I added moderation features to the platform. Admins can review and ban/delete accounts if necessary. Shadow banning was also considered, but deemed unnecessary.

The next step was a really simple end-to-end pipeline of how a user goes through the spam pipeline. Choose a trigger word (eg: "call girls"), flag the users and let a human deal with the results. This got multiple things going: review and suspend users (true positives) or mark them trusted (false positives). Which left me with one pretty important problem to solve...


## Step 2: Classify the users automatically

This is the core of the whole operation. How do you detect users posting spam content accurately? There's two ways of going about it: using machines or using humans.

#### Machine learning or human touch

Machines are fast and cheap, but even the best trained are prone to make mistakes. Humans are slow and accurate but expensive. A machine learning model needs data for classification. I was just kicking things off and there was no training data yet.

I settled on a mix of the two approaches. Instead of classifying into _true_/_false_ dichotomies, assign a score to each user. Then I could use a configurable threshold to choose a point when humans take over.

#### Choose your input parameters

Once you're using machines, you need to decide on a classification approach. Is it text or images/videos? Visual classification is an inherently different problem compared to text classification and you'll need to approach them as two different problems. I was focussing on only text classification for now.

#### Choose your balance

You'll never catch 100% of the spammers. Contend with a few bad actors being around. There's still a choice to be made. Do you want fewer false positives or fewer false negatives. As depicted in this classic example:

![Classification problem](/images/2021/classification.jpg)

#### Machine classification

While there's many SaaS which offer APIs for classification, I ran into their limitations quickly. For example, [Hive](https://hivemoderation.com/text-moderation) is limited to 1024 characters and in my limited tests with their demo it didn't detect many sample inputs as spam.

On the other hand, there's also regex heavy spam detector like [Smoke Detector](https://github.com/Charcoal-SE/SmokeDetector) which is a community built and used for StackExchange Chat. For me this was the clear winner. Regexes are a powerful tool for scanning text and regex based triggers are predictable, boring and easy to debug.

## Step 3: Sit back

I used a regex to count how often a trigger word appears in a users' profile and used that to assign a score to each profile. I picked two thresholds: one results in automatic suspension (which the user can appeal in case of false positive, none so far) and the other one lets a human review the profile.

The spam detector has been chugging along. There's minimal intervention required, except for false positives. One tiny tweak I had to make to my code was to use [unicode normalisation](https://en.wikipedia.org/wiki/Unicode_equivalence) while processing text to detect obfuscated spam.


## Conclusion

A few weeks after the spam solution was in place and kicking spammers asses to oblivion, the support received a proposal from one of the spammers. And it felt like victory. The spammer wished for a designated account in exchange for a monthly fee where they could post their spam. Their offer was promptly and politely turned down.
