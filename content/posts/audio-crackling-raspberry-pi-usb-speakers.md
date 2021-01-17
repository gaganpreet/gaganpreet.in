---
title: Fixing crackling audio on USB powered speakers and Raspberry Pi
author: gagan
date: 2020-08-26T00:00:00+00:00
categories:
 - hacking
tags:
  - raspberry-pi
  - crackling
  - popping
  - usb

---

### Powering USB speakers from Raspberry Pi

I recently set up Mycroft (an open source personal assistant) on my Raspberry Pi. I bought a set of cheap speakers which run on USB power and plugged them into the 3.5mm output and the power cable to a USB port on the Pi itself. Right away I heard constant crackling noises coming out of the speakers. I figured I had a set of defective speakers but I could not reproduce this when I tried the same setup with my laptop.

### Solution 1 - Separate wall charger

I did some digging, and it turned out that this is a common problem. The reason for the static noise is that both Pi and speakers share the same power source, which transforms to analog noise in the output of the speaker. For the time being, I powered the speakers from a spare USB wall adapter I had lying around and the noise disappeared.

### Solution 2 - Ground loop isolator

Another remark I came across was a suggestion to connect the speakers via a small device called the ground loop isolator. It's a little device with two female 3.5mm audio ports. One side for input and another for output. I was curious if it'd actually work and I ordered one from Aliexpress for a couple of euros. I received the ground loop isolator in my mail and it worked like a charm. Speakers are now powered directly from the Raspberry Pi and the 3.5mm cable plugged into the same device with the ground loop isolator in between.

#### Conclusion

If your USB powered speakers are generating static noise on your Raspberry Pi: either invest in a **separate wall charger** for the speakers OR a **ground loop isolator**.
