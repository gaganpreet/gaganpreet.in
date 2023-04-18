---
title: "Copy to clipboard from tmux on a remote ssh session"
date: 2023-02-08T22:39:37+01:00
slug: tmux-ssh-remote-clipboard
draft: false
---

Note: A better approach is documented [in this blog post](https://www.babushk.in/posts/renew-environment-tmux.html) by Igor Babuschkin.

My current working setup is tmux + neovim. On top of that, I use my desktop for development that I often access remotely outside of home.

One of the drawbacks of working remotely via SSH was that I couldn't copy to my client's native clipboard (eg: to share code snippets in Slack) remotely.

It took me some time to figure out how to do it, and it's quite straightforward.

There are three steps:

- Run `ssh` with either the `-X` (trusted X11 forwarding, preferred) or `-Y` (untrusted X11 forwarding) switch.
- Before attaching tmux, get the value of `DISPLAY` env var (`echo $DISPLAY`). Make a note of it.
- After attaching the tmux session, export `DISPLAY` to this value.

And that's it. The `-X` switch is intuitive. However, it's setting the DISPLAY environment variable that's the key. My tmux sessions usually originated on my desktop, where the value for `DISPLAY` would be `:0`. When I am on an ssh session, this value is `:10.0`. Without setting this environment variable, the `xsel` command will point to the wrong display.
