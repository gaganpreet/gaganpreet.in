+++
title =  "IPython embed and autoreload"
date = 2020-12-07T21:01:38+01:00
featured_image = ""
description = ""
categories = ["programming"]
tags = ["productivity", "autoreload", "ipython", "python", "programming", "embed"]
+++

IPython makes for very productive and effortless sessions working interactively with Python. From the numerous extensions for IPython, [autoreload](https://ipython.readthedocs.io/en/stable/config/extensions/autoreload.html#autoreload) is one I use often. It's very useful for working with existing code and being able to edit code from my code editor and have changes reflected automatically within the IPython terminal.

<!--more-->

Enabling it is straightfoward:

```python
%load_ext autoreload
%autoreload 2
```

### Embedded shells

Unfortunately, this approach doesn't work reliably when an IPython shell is embedded programatically using code. For example, shell which will initialise a Flask app's factory method before embedding. This is a long standing issue on IPython's Github [project tracker](https://github.com/ipython/ipython/issues/1144).

After some searching, I found an elegant solution on [Github](https://github.com/search?l=Python&q=ipython+autoreload+embed&type=Code)

### Custom shell.py

My shell.py now looks like this:


```python
from IPython.terminal import embed

from app.models import *
from app.db import db


if __name__ == "__main__":
    terminal = embed.InteractiveShellEmbed()
    terminal.extension_manager.load_extension("autoreload")
    terminal.run_line_magic("autoreload", "2")

    db = get_db()

    terminal.mainloop()
```

### In action

Small demo of this customised shell in action:

![In action](/blog/static/2020/12/ipython.png)


### Caveat

Autoreload will break reloading modules containing SQLAlchemy models because the models are registered in an SQLAlchemy namespace.
