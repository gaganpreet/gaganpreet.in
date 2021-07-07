---
title: "Optimising a Vuetify app"
date: 2021-07-07T14:53:00+02:00
images:
    - /images/2021/vuetify-after-page-speed-score.png
---

## Background

I've been building [No Cookie Analytics](https://nocookieanalytics.com/) in Vue using the Vuetify framework. Most of my time was spent hacking away without any due regard to performance. I looked at the PageSpeed Insights score, which handed out an abysmal score of 29 (out of 100). It was not shocking, I hadn't spent any time on this part. The app _was_ sluggish and I knew I had to fix it. Here's my before and after scores with the steps I took to optimise the app:

|          |                    |   |
|----------|--------------------|---|
|![Before score ](/images/2021/vuetify-before-page-speed-score.png) |to|![After score ](/images/2021/vuetify-after-page-speed-score.png)|

This screenshot is of the mobile score. (The desktop score is a perfect 100).

Here's how I optimised the app.

## 1. Import only used icons

The default Vuetify setup bundles the whole material design icons CSS, a dependency clocking in at over 250 KB. For only a tiny subset of the icons I was using, this was the first thing to be removed. 

### Default

```html
<!-- bad -->
<link
    href="https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css"
    rel="stylesheet"
>
```

### Better (import only used icons)

Instead use `@mdi/js` and include icons in global Vue instance piecemeal like this:

```vue
// Initialising Vuetify
import { mdiClose } from '@mdi/js';

export default new Vuetify({
  icons: {
       close: mdiClose,
	   ...
	}
});

// In component template
<template>
	<v-icon> {{ $vuetify.icons.values.close }}</v-icon>
</template>
```

And that's it for registering icons and using them globally.

But if you are, say, using 100 icons across your whole app but only on a few pages it doesn't make sense to bundle all into the main chunk. In that case it's better to import icons a la carte within each module and use it only for that module like this:

```vue
// Vue Component
<template>
  <v-icon>{{ svgPath }}</v-icon>
</template>

<script>
  import { mdiAccount } from '@mdi/js'

  export default {
    data: () => ({
      svgPath: mdiAccount
    }),
  }
</script>

```

## 2. Get rid of moment.js locales

Moment.js has been superseded by better alternatives which support tree-shaking, but some packages might still need it. I couldn't get rid of moment.js altogether, but I could disregard all locales that were always bundled with moment.js.

```javascript

// vue.config.js

const webpack = require('webpack');

module.exports = {
  configureWebpack: {
    plugins: [
      new webpack.IgnorePlugin({
        resourceRegExp: /^\.\/locale$/,
        contextRegExp: /moment$/,
      }),
    ],
  },
```

## 3 Setup tree-shaking for vuetify

The default vuetify setup, again, bundles everything into the final build even if a component isn't used. The solution here is to setup tree-shaking, [documented on their website](https://vuetifyjs.com/en/features/treeshaking/).

```vue
// Before
import Vuetify from 'vuetify';
// After
import Vuetify from 'vuetify/lib';
```

Add vuetify loader

```vue
// vue.config.js
const VuetifyLoaderPlugin = require('vuetify-loader/lib/plugin');

module.exports = {
  configureWebpack: {
    plugins: [
      new VuetifyLoaderPlugin(),
	  ...
    ]
  }
};
```


## 4 Add gzip and cache headers

My docker image exposes static assets with a nginx server, which has no compression enabled by default. I modified the nginx configuration to compress these assets:

```nginx
gzip on;
gzip_vary on;
gzip_min_length 10240;
gzip_proxied expired no-cache no-store private auth;
gzip_http_version 1.1;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml image/png;
gzip_disable "MSIE [1-6]\.";

location /static {
  root /usr/share/nginx/html;
  expires 1y;
  add_header Cache-Control "public";
}
```

This is only gzip compression, there are third party nginx docker images out there which also support brotli, a more efficient compression algorithm.

## 5 Resize big images

Simple one: I had a png original which was 1500x1500px weighing in at 500 KB, which I scaled to 100x100px, resulting in an almost negligible image of just a couple of kilobytes.

## 6 Replace huge modules

Replace huge modules. Use `yarn build --report` and check `dist/report.html` in browser. I replaced these components:

* Date picker, which pulled in moment.js. This was replaced with another package which is self contained and didn't depend on another date library.
* vue-charts, a package based on Chart.js 2.x, which doesn't have tree shaking. Bundling a fully featured chart library when all I needed was line charts was superfluous. [uPlot](https://github.com/leeoniya/uPlot/) provides a much leaner alternative.
* Instead of bundling all country flags into the build, I serve them as static assets from the public directory which can be included as images wherever needed.


## 7 Optimise CSS using cssnano

cssnano optimises CSS to a semantically equivalent result, but with unnecessary fluff removed. I added this to my vue.config.js to get cssnano to optimise my built CSS.

```typescript
// vue.config.js

  chainWebpack: (config) => {

    config.module
      .rule('css')
      .oneOf('normal')
      .use('postcss-loader')
      .tap((options) => {
        options.plugins.unshift(require('cssnano'));
        return options;
      });
  }
```

## 8 Optimise CSS with purgeCSS (part 2)

PurgeCSS removes unused CSS. Because it's a "destructive" tool, it's not straightforward to configure as without a proper ruleset it's easy to remove CSS which the app needs. But this is the only way to drastically reduce the CSS size. Initially I copied a purgecss configuration from another project, but it turned out to be not as efficient as it still bundled a few things I didn't need. So I [researched a better purgecss config (link to my purgecss configuration)](https://github.com/nocookie-analytics/core/blob/2dc44215ee8335ce8cde790cad8e0c24019e3658/frontend/purgecss.conf.js) matching my needs.


## 9 Blacklist used chunks from being prefetched

The vue app included prefetch links for all Javascript chunks of the app. This wasn't ideal so I blacklisted them all so these will be loaded on demand:

```javascript
chainWebpack: (config) => {
  if (config.plugins.has('prefetch')) {
     config.plugin('prefetch').tap((options) => {
        options[0].fileBlacklist = options[0].fileBlacklist || [];      
        options[0].fileBlacklist.push(/\/users-.*/);
        options[0].fileBlacklist.push(/.*map$/);
        return options;
    });
  }
}
```

## Conclusion

While I managed to achieve some significant improvement in the page speed score, it could still be better. I didn't want to sink a lot of time into this at this point where the last set of improvements would only have been diminishing returns, so I stopped for now.
