---
title: "Copy to clipboard from tmux on a remote ssh session"
date: 2023-02-08T22:39:37+01:00
slug: tmux-ssh-remote-clipboard
draft: false
---

**Updated in October 2024, to work with Wayland and native OSC-52 support**

My current working setup is tmux + neovim. On top of that, I use my desktop for development that I often access remotely outside of home.

One of the drawbacks of working remotely via SSH was that I couldn't copy to my client's native clipboard (eg: to share code snippets in Slack) remotely.

OSC-52 has been around for a while and has been adopted gradually which is what I used to get a working copy paste working on my remote tmux session. Note that all layers of communication from the terminal to the editor need to support OSC-52 and have the feature enabled.

My current setup, therefore, relies on these:

- Kitty
- tmux
- Neovim


## Kitty

Supports OSC-52 out of the box as far as I know.

## tmux

tmux needs the following config variables to enable OSC-52 support:

```
set -s set-clipboard on
set -g allow-passthrough
```

## Neovim

I added the following lines to my neovim config to copy to my system clipboard (also works on remote ssh sessions):

```vim
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
```

<details>
<summary><b>Old section of the post, works only on X11</b></summary>
It took me some time to figure out how to do it, and it's quite straightforward.

There are three steps:

- Run `ssh` with either the `-X` (trusted X11 forwarding, preferred) or `-Y` (untrusted X11 forwarding) switch.
- Before attaching tmux, get the value of `DISPLAY` env var (`echo $DISPLAY`). Make a note of it.
- After attaching the tmux session, export `DISPLAY` to this value.

And that's it. The `-X` switch is intuitive. However, it's setting the DISPLAY environment variable that's the key. My tmux sessions usually originated on my desktop, where the value for `DISPLAY` would be `:0`. When I am on an ssh session, this value is `:10.0`. Without setting this environment variable, the `xsel` command will point to the wrong display.
</details>
