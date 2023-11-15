+++
title =  "Tools for working with JSON"
date = 2023-10-25T00:02:40+02:00
featured_image = ""
description = ""
tags = []
categories = []
+++

I often work with JSON responses and need to process, view or compare objects. I have come to depend on a bunch of command line tools for these tasks. Do you use any other tools? Let me know in comments below.

## View (bat)

[`bat`](https://github.com/sharkdp/bat) (better cousin of cat) is perfect for reading syntax highlighted JSON. It'll use a pager for files that don't fit on the screen and files can be searched by using the `/` operator.

#### Usage

```bash
bat data.json
```

## View - second tool (gron)

An alternative to browsing JSON is using [gron](https://github.com/tomnomnom/gron). It makes JSON greppable. Very handy for deeply nested objects

```bash
gron 'https://api.github.com/users/github/followers?per_page=1' | grep id
```

```javascript
json[0].gists_url = "https://api.github.com/users/bruce/gists{/gist_id}";
json[0].gravatar_id = "";
json[0].id = 72;
json[0].node_id = "MDQ6VXNlcjcy";
```

## Process (jq)

If the API I'm working with returns data without indentation (everything on a single line), I use [`jq`](https://stedolan.github.io/jq/) . More commonly, I end up piping the output to bat

#### Usage

```bash
curl https://api.github.com/users/github/followers | jq | bat -l json
```

Another practical use of jq is to sort keys:

```bash
curl https://api.github.com/users/github/followers | jq -S
```

This barely touches the tip of the iceberg for `jq`. It's a very useful and powerful tool and learning it is well worth the effort.

Once the keys are sorted, it's pretty easy to compare two JSON files using `diff`:

```bash
diff <(echo '{"a": 1, "b": 2}' | jq -S) <(echo '{"c": 3, "b": 2, "a": 1}' | jq -S)
```

## Compare (jd)

In the previous example, `jq -S` will sort keys, but if there is an array of objects, the order of the objects in the array will not be sorted.  However, in some cases, the order of the objects in the array is not important.

When I need to compare huge JSON blobs, I find [`jd`](https://github.com/josephburnett/jd) to be very useful. It's a command line tool that can be used to compare JSON files. The `-set` flag ignores the order of the objects in an array (treating the array as a set).

## Conclusion

These are the tools I use most often when working with JSON. If you have any other tools that you use, let me know!
