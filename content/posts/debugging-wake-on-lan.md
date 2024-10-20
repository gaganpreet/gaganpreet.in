---
title: "Debugging Wake on Lan"
date: 2024-08-31T09:23:34+02:00
---

I rely heavily on Wake-on-LAN to wake my desktop and ssh in for working remotely. Last month I ran into an issue; Wake-on-LAN wasn't working. I had to physically press the button or press a key on the keyboard to wake up my desktop.

Over a weekend, I sat down to figure out what was going on.

### Setting the wake-on flag manually

The [Arch Wiki Wake-on-LAN](https://wiki.archlinux.org/title/Wake-on-LAN) page has a bunch of suggestions on how to get Wake-on-LAN working correctly, but it wasn't obvious to me what had changed in a system that had been working fine for over two years. Running `sudo ethtool enp34s0  | grep Wake-on:` showed that `Wake-on` value was `d`, disabled.

I set it to enabled (`sudo ethtool -s enp34s0 wol g`), put the  machine to sleep, and turned it back on. In a couple of minutes after waking it up, I noticed the flag was disabled again.

### Digging into logs

I started `dmesg -wT` in one window and in another shell I ran a while loop to observe Wake-on-LAN flag status shown in ethtool.

The machine woke up with the flag being set to `g` (good!). Approximately 10 seconds after the machine resumed from sleep, the flag would somehow be disabled (`d`). The only log entries in dmesg were unrelated ones with a disk:

```
Jul 26 22:55:44 geektower kernel: ata1.00: qc timeout after 10000 msecs (cmd 0x40)
Jul 26 22:55:44 geektower kernel: ata1.00: VERIFY failed (err_mask=0x4)
Jul 26 22:55:44 geektower kernel: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
Jul 26 22:55:44 geektower kernel: ata1.00: revalidation failed (errno=-5)
```

A network device being affected by a hard disk was pretty weird but that was the only thing to go on for now.
### Debugging with systemd

I put [systemd in debug mode](https://systemd.io/DEBUGGING/) by changing the parameters on the bootloader. I did the same thing: put the machine to sleep, observed the changing status of the Wake-on-LAN flag in ethtool and this time I ended up with a lot more log messages. One thing stood out to me, these two lines:

```
Jul 27 22:39:07 geektower (sd-exec-strv)[9707]: About to execute /usr/lib/systemd/system-sleep/tlp (null)
Jul 27 22:39:07 geektower (sd-exec-strv)[9707]: /usr/lib/systemd/system-sleep/tlp succeeded.
```

`tlp` is a tool for optimising battery life for laptops and it was strange that it was running on my desktop. I enabled the wake on flag (`sudo ethtool -s enp34s0 wol g`), ran the command `/usr/bin/tlp` manually and bingo! The tlp command disabled the wake on flag.

### Culprit and fixing it

Once I had the culprit, `tlp`, I disabled tlp service (which is unnecessary on a desktop from what I understand). For good measure, I edited my tlp config in `/etc/tlp.conf` to not disable WOL. I can see when tlp was installed on my desktop, and the package has been around for a while but I'm not sure when and how it was enabled, but it's a mystery I'm not sure how to debug.
