---
title: "Wikivoyage has disappeared from DuckDuckGo"
date: 2021-10-26T12:43:04+02:00
typora-root-url: ../../static

---

I have been planning a long due vacation and I was doing some research into the places I wanted to visit. My goto travel guide is Wikivoyage: it's well organised, text-heavy (instead of slideshow-heavy alternatives) and skimming the guide of a region will generally give a good idea of what to expect.

So imagine my surprise when I enter a query with the keyword "Wikivoyage" on DuckDuckGo:

![Wikivoyage Malta DuckDuckGo](/images/2021/wikivoyage-ddg.png)

There's a lot of results shown on the page, but the takeaway is that results linking directly to **any page on Wikivoyage** have completely vanished from DuckDuckGo.

### DuckDuckGo's data source: Bing

Since [DuckDuckGo uses Bing as a primary source](https://help.duckduckgo.com/duckduckgo-help-pages/results/sources/), I retried the same query on Bing. Completely different results compared to DuckDuckGo. The first result links directly to Wikitravel. Wikitravel is the original project and a schism in the project resulted in the creation of Wikivoyage, with Wikivoyage taking the mantle of being the more active project over the last few years.

![Wikivoyage Malta Bing](/images/2021/wikivoyage-bing.png)


If I scroll down to the bottom of the Bing page, I see this message: ["Some results have been removed"](http://go.microsoft.com/fwlink/?LinkID=617350), a generic page which doesn't have any info about which results were excluded and why.

For what it's worth, I repeated the same query on Yahoo (which also uses Bing as a source), and got similar results. So we have three search engines: DuckDuckGo, Yahoo and Bing from where Wikivoyage has completely disappeared.

### Is it robots.txt?

At this point I wondered if Wikivoyage deliberately blocked Bing crawlers, but there's nothing in their robots.txt blocking access to Bing crawlers. I also changed my [user agent to match Bing's](https://www.bing.com/webmasters/help/which-crawlers-does-bing-use-8c184ec0), and Wikivoyage pages loaded just fine.

### You *can* search Wikivoyage on DuckDuckGo

There's a way to get Wikivoyage results on DuckDuckGo, by using the `site:` operator.

![Wikivoyage Malta DuckDuckGo with site: operator](/images/2021/ddg-wikivoyage-site-operator.png)

On the other hand, Bing has an empty page with the same query:

![Wikivoyage Malta Bing with site: operator](/images/2021/bing-wikivoyage-site-operator.png)

Wikivoyage is probably blacklisted at Bing's end for some reason and that percolates downstream to both Yahoo and DuckDuckGo. But that doesn't explain why DuckDuckGo can return Wikivoyage results with the site operator while Bing doesn't.

### Back to Google

I can still find Wikivoyage on Google. What concerns me is how obscurely the results have disappeared from three search engines, which also happen to command a fair share of the market after Google. I also can't help but think there's a sense of irony in how DuckDuckGo claims to be less biased than others, but is unable to do that (perhaps due to no direct fault of their own).
