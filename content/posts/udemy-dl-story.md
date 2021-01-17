---
title: The story of udemy-dl
author: gagan
date: 2020-10-25T00:00:00+00:00
categories:
 - programming
tags:
 - udemy-dl
 - youtube-dl
 - dmca
 - github

---

The recent takedown of the [youtube-dl](https://github.com/github/dmca/blob/master/2020/10/2020-10-23-RIAA.md) project resurfaced memories of a similar project, udemy-dl, that I worked on years ago. I also had to abandon the project due to a DMCA notice. In light of what happened to youtube-dl this felt like the right time to write about it.

## Beginnings

Back in 2013 when I was starting off as a software consultant, I landed a project to build a desktop GUI application. I found a Udemy course for Python GUI development using Qt. After I started the course I ran into an obstacle. My internet was awful. It was slow (4 Mb/s, if I remember correctly) and disconnected frequently making streaming videos a painful experience.

A look at the network console in the browser made me realise I could throw together a quick scraper for the script.

And so I did. I wrote a Python script to fetch the course data and video URLs from the undocumented Udemy JSON API, and download the videos locally. Finally I could follow the videos in VLC at my leisure.

It was only some time later I realised that youtube-dl also supported downloading from Udemy. However, youtube-dl could only download a single video from one page at a time. udemy-dl could download and make a whole course offline, a big improvement.

I put my work online, with a name inspired by youtube-dl. I hosted the sources on [Github](https://github.com/gaganpreet/udemy-dl) and packages on [PyPi](https://pypi.org/project/udemy-dl/). That was it. I never advertised udemy-dl or created a website (except for a readme on Github).

## Gaining momentum

Turns out I wasn't the only one who wanted to have an offline copy of their lectures. A year or so after the project was first published online, there was a gradual uptick in number of Github stars.

I also started receiving emails from users of the tool. Many looking for help with a particular issue and some thanking me for the project. I had stopped using the Udemy platform itself by this time since I wasn't following any courses, and was only a maintainer.

## Gaining notoriety

I discovered that the tool was being used to provide unauthorized copies of courses. The tool was always meant for personal use, and unfortunately I had no control if users respected that.

I also learned of a loophole when someone made a feature request to add to the tool. Udemy offered a free 5 minute preview where all course content was accessible. This trial period could be used to download the course without having to pay.

This feature never made it to the project. Later I came across modified copies of the tool which did this: sign up for a course and quickly download the content within this short window. 

In April 2015 I received a gently worded email from Udemy telling me that the project was being used for piracy and if I'd be willing to take down the tool altogether. I didn't want to do that and I ignored the email. In retrospect, I could have replied and elaborated on my standpoint about why I wouldn't do that. I doubt that would have helped at all.

I didn't expect the project to go away. youtube-dl also existed, a much bigger project could also download Udemy videos. I presumed udemy-dl would always be around as long as youtube-dl. 


## Takedown

One fine day later in the summer of 2015, I woke up to a DMCA email from Github informing me of the takedown notice sent by Udemy. For a while afterwards I wanted to respond to the DMCA. The [DMCA notice](https://github.com/github/dmca/blob/master/2015/2015-08-12-Udemy.md) centered around the point that the project I created, maintained and released to public domain was a property of Udemy, a completely wrong claim.

Unfortunately I had no idea where to start off with responding to a DMCA. My knowledge of American law, as an outsider was (and still is) nil. Due to other personal circumstances at the time and the fact that I was solely maintaining the project (and not using it), I gave up on the idea. The ownership of the project was forked/taken over by a former regular contributor (that fork was again taken down a few years later with a similar DMCA notice).


## Why it matters

udemy-dl served a great need for me and many others. Being able to watch videos and learn the way I wanted without having to be online or without opening a browser was the reason it existed and became popular. A platform which purpots to make education accessible, didn't like a piece of code which served the same purpose.

youtube-dl was the latest victim. Apart from software projects, it's not uncommon to have videos on Youtube taken down by the greedy claws of the music industry. So unfair that there exists a [Wikipedia](https://en.wikipedia.org/wiki/YouTube\_copyright\_issues) page about the issue.

What has always troubled me is that a law as powerful as DMCA is used to intimidate all too often, with no easy recourse for the receiver. The law has provisions for unauthorized use, but good luck if you are an indie creator going up against a corporation.

youtube-dl is a huge loss because of the number of websites it supported, with many of the websites having unusable interfaces. I'm certain that youtube-dl will live on, but it's on Github where it had a huge community which has now been scattered. And I hope we don't lose this community forever.
