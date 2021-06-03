---
title: "Lessons learnt migrating a Flask application to Python 3"
date: 2021-06-02T12:11:26+02:00
images:
    - /images/2021/python3-unsplash.jpg
---
![Gears](/images/2021/python3-unsplash.jpg)

I recently migrated a medium sized Flask application from Python 2 to Python 3. Python 2 was retired over a year ago and upgrading the app was long overdue. I imagine there are still others who could use my lessons to migrate their apps.

### Background

A medium sized Flask application, ~20000 LoC running on Heroku with multiple celery workers. The app was already using the latest version of Python 2.7, which is an necessary stepping stone from 2.x to 3.x.

---------

## Step 0: Preparations 

## **Setup a CI pipeline with Python 3.8**

I extended the existing Github Actions workflow with a [matrix to run a parallel workflow with an experimental flag](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#example-including-new-combinations). The experimental flag allowed the action to fail without failing the whole pipeline. At this point nothing worked due to multiple incompatible pip dependencies. The app also failed to start in Python 3 due to multiple import errors.


## **Fix/Replace incompatible packages**

[caniusepython3](https://pypi.org/project/caniusepython3/) is a Python tool that uses trove classifiers on PyPi to find which packages are compatible with Python 3 (and which aren't). While the tool itself is flawless, there were some projects which are don't list proper classifiers. I manually sifted through ~10 incompatible dependencies found by the tool and found about half of them will have to be either upgraded to newer versions or migrated to suitable replacements.

A handy way is to specify two different versions of the same package (eg: if there's no single version of a package which is compatible with both Python 2 and Python 3) is to use [environment markers](https://www.python.org/dev/peps/pep-0508/#environment-markers) in `requirements.txt`. For example, enum is part of Python 3, but in Python 2.7 I added this to requirements.txt

```
enum34 ; python_version=="2.7"
```

## **Replace urlopen/urllib2**

`urllib2` was removed and reorganised into several modules in Python 3, so I took the opportunity to replace scattered usages of this module with `requests`.


---------

## Step 1: Futurize everything

I used [futurize](https://python-future.org/futurize.html) for a huge chunk of automated changes. To ensure that no regressions were committed to the main branch, I added a pre-commit hook with a custom shell script:

```yaml
# pre-commit hook definition
-   repo: local
    hooks:
    -   id: check-futurize
        name: Futurize
        entry: /bin/bash futurize.sh
        language: script
        files: \.py$
```

```bash
#!/bin/bash -eou pipefail
# futurize.sh

# A pre-commit hook script to ensure we don't regress on
# already made changes for Python 3 migration

pip install wheel
pip install future

futurize -j 4 --stage1 --write --nobackups "$@"
```

## Futurize stage1 - safe fixes

Futurize has two stages, with the first stage categorised as "safe fixes". Unfortunately, due to the structure of the project, the result of applying this fix resulted in a borked app. Python 2 allowed a laissez-faire method of implicit relative imports. Changing these relative imports to absolute imports created some cyclic imports in the app. There's no easy way to fix this but by going through each cyclic import at a time and fix them.


## Use futurize stage 2 fixes

Futurize stage 2 uses shims/wrappers to fill in gaps where Python 2 and Python 3 differ. For example, the `urlparse` module in Python 3 has a completely different import path than before. A naïve approach would be to do this:

```python
##################################################################################
# Version 1: Simple but verbose
##################################################################################
import six

if six.PY2:
     from urlparse import urlparse
else:
     from urllib.parse import urlparse

##################################################################################
# Version 2: Clean and elegant, from `fix_future_standard_library` futurize fixer
##################################################################################

from future import standard_library
standard_library.install_aliases()

from urllib.parse import urlparse
```

The second stage of futurize was a lot of changes to sift through for correctness, and I found it easier to go through one by one. I retrieved a list of available fixes one by one using `futurize -l --stage2`, and then applied each fix one by one:

```bash
futurize --stage2 --write --nobackups -j 4 \
    -f lib2to3.fixes.fix_dict \
    **/*.py
```

With every change, I also updated the `futurize.sh` script which was used by pre-commit hook. Gradually, I arrived at a milestone where all futurize changes had been applied to the codebase, and no one was able to commit deprecated code because of the hook.


## Build unicode sandwich

Python 2 allowed a wild-west approach to bytes and unicode strings which is handled lot saner in Python 3. Unfortunately  because of this change, unicode strings is the most challenging part of any Python 2 to 3 migration.

The answer to this dilemma is the unicode sandwich: always work in unicode, and decode/encode bytes at boundaries.

Here I relied on signals from failing tests which covered most of the occurences. For some critical sections, I added type annotations which pointed out yet more inconsistencies. A few more were discovered using [Pyright](https://github.com/microsoft/pyright/), a static type checker for Python. Pyright easily found cases where a file was opened in text mode (default in Python 3), but had bytes being written to it.

---------

## Step 3: Deploy


At this point I had a fair amount of confidence in the work done so far. I moved development Docker images to Python 3 and a week later the staging environment was also running the new Python. On the planned day the Python runtime on Heroku was updated to Python 3. With a few unicode/bytes related exceptions (caught by Sentry) which broke minor parts of the website everything went smoothly.

---------

## Step 4: Cleanup

Remember those `__future__`, `past.builtins`, `six` imports introduced in Step 2 by futurize? Moving forward the app will only run in Python 3, I could get rid of (almost) all of those imports and remove other Python 2 specific code. [pyupgrade](https://github.com/asottile/pyupgrade) made this update a breeze, and it also comes with a pre-commit hook to enforce Python 3 standards across the codebase.


## Conclusion

The migration changes occurred over a course of a couple of months of working part-time. Adopting a piecemeal approach starting from running the old incompatible app in Python 3 to applying futurize code fixers on at a time resulted in atomic changes to not interfere/cause issues for the parallel development cycle by other engineers. To conclude, here's a list of useful tools/utilities I used to make this job easier:

* [caniusepython3](https://pypi.org/project/caniusepython3/)
* [futurize](https://python-future.org/futurize.html)
* [futurize pre-commit hook](https://pre-commit.com/)
* [pyupgrade](https://pypi.org/project/pyupgrade/)
