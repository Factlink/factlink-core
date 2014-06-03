## Factlink.com core repo

[![Build Status](https://travis-ci.org/Factlink/factlink-core.svg?branch=master)](https://travis-ci.org/Factlink/factlink-core) [![Dependency Status](https://gemnasium.com/Factlink/factlink-core.svg)](https://gemnasium.com/Factlink/factlink-core) [![Code Climate](https://codeclimate.com/github/Factlink/factlink-core.png)](https://codeclimate.com/github/Factlink/factlink-core) [![Code Climate](https://codeclimate.com/github/Factlink/factlink-core/coverage.png)](https://codeclimate.com/github/Factlink/factlink-core)

Factlink is an open-source project with the mission to make the world more open and credible by discussing everything.

## Background

This project used to be run by Factlink Inc., and is now a community project. We welcome new features and bugfixes, and support sharing code with other projects. All our projects are liberally licensed (MIT), allowing for maximal reuse. For more background information about Factlink, please check out our blog: https://factlink.com/blog.

Factlink is being maintained by @markijbema, @janpaul123, @martijnrusschen, and @EamonNerbonne.

## Installation

Set up requirements such as node, postgres, and so on, by using one of the bootstrap scripts: `bin/bootstrap-linux`, `bin/bootstrap-mac`, or in `bin`. (Or read those files to verify you've got everything.)

Then you're basically set!

You can start factlink by running

```
./start-all.sh
```

If you want more fine-grained control, the local db+bundler dependencies can be installed with `bin/bootstrap`, and the db without anything else can be started with `./start-db.sh` and the web-servers without the db or bootstrapping with `./start-web.sh`.

`./start-all.sh` avoids overheard by not running various bootstrap steps unnecessarily - to do so it compares sha1 hashes of the last executed code version with the current situation.  If every things go haywire, just delete `*.sha-cache` and everything will be re-bootstrapped.

Now open your browser and surf to http://localhost:3000

## Running the tests

See `.travis.yml` for various tests that we run.

Screenshot tests can be tricky. On some systems they run correctly (typically Linux), which you can verify using `bundle exec rspec spec/screenshots` on master. If that works, you can update screenshots after running the tests using `bin/update_screenshots_locally.sh`. If the screenshots don't match locally, just let Travis build your branch, and look for imgur uploads. Then use the provided commands to download the images. Please remove the `*-diff.png` files before committing, they are just for debugging purposes.

## Architecture

There's quite a bit of legacy in our application, which we have tried to clean up over time. However, there are still some quirks in our application architecture. We would like to help you understand our application.

### Different repos

- **factlink-core:** The repo you're looking at. Runs the factlink.com website, and the discussion page that runs in an iframe ("client page"). This bootstrap script in this repo will checkout "js-library" and "web-proxy" repos in subdirectories, and start servers for them, to make development easier. See `start-web.sh` and `bin/bootstrap` for details.
- [**js-library:**](https://github.com/Factlink/js-library) The Javascript annotation library that is included on websites, browser extensions, and in the proxy. The production version is hosted here: https://factlink.com/lib/dist/factlink_loader.min.js. The js-library opens https://factlink.com/client/blank in an iframe, and communicates with factlink-core using a postMessage API, using a wrapper that we call "envoy". The js-library is included on production using a [rails-assets](https://rails-assets.org) gem.
- [**web-proxy:**](https://github.com/Factlink/web-proxy) Proxies arbitrary pages, and injects a script tag to the js-library. Runs on fct.li. It also detects if Factlink is already inserted on that page, in which case it just redirects.
- [**browser-extensions:**](https://github.com/Factlink/browser-extensions) Extensions for Chrome, Firefox, and Safari. Just inserts script tag to js-library.
- [**wordpress-plugin:**](https://github.com/Factlink/wordpress-plugin) Loads js-library on a Wordpress blog, with some controls to specify on which pages it should load exactly.
- [**pivotx-plugin:**](https://github.com/Factlink/pivotx-plugin) Loads js-library on a PivotX site.
- [**url_normalizer:**](https://github.com/Factlink/url_normalizer) Gem for converting an arbitrary URL to a canonical URL. Used for attaching annotations to a canonical URL.
- [**factlink_blacklist:**](https://github.com/Factlink/factlink_blacklist) Regexes that matches URLs on which Factlink should be disabled for technical or privacy reasons. Generates a regex that can be used in browser extensions and such.

### Terminology

- **annotation = fact = FactData = "factlink":** A piece of text annotated on a website.
- **comment:** A comment on an annotation.
- **subcomment:** A comment on a comment.
- **upvote = believes, downvote = disbelieves, tally:** Votes on comments. Terminology comes from our credibility calculation.
- **client:** Pages that are shown within a transparent iframe through the js-library on someone else's site. Currently this is only the discussion page.
- **publisher:** A publisher is a person, company, or website that has Factlink installed on their site. A canonical example is our own blog, on which you can use Factlink without installing a browser extension.

### Backend

Actual backend functionality is a bit scattered between Rails controllers, ActiveRecord models, "Backend" classes, [Pavlov](https://github.com/Factlink/pavlov) interactors, and "dead objects". This is the direction we were going: controllers and models shouldn't really do anything, the "Backend" classes are for interacting with the database through the models, and use case logic is in controllers. The reason for this is that we switched databases from Mongo/Redis/Elasticsearch to only Postgres.

Our application is mostly a single-page-app in React, with the backend consisting of JSON APIs. All interactors should return "dead objects" (of which we can be sure they have no database interaction) which are directly serialised to JSON.

Sign in/up screens all open in popups, because people need to be able to login from the discussion page, which is loaded in an iframe. The sign in/up flow does not follow the single-page-app/JSON paradigm, but is a traditional Rails flow.

Activity mails are sent asynchronously using SuckerPunch, which does not require an additional worker, since we run on Heroku.

### Frontend

We use Backbone for our data layer, and for communicating with the JSON APIs. For rendering and interaction we use React. For popups and tooltips we use Tether, which spawns a new React component in the body and keeps it positioned next to any arbitrary React component.

We use SCSS for stylesheets, and explicitly don't use any nesting, but scoped class names instead. This is to prevent naming collisions and to make it easier to find things. We try to keep style interactions as local as possible.

### Servers

We currently run on Heroku, with a Postgres database, Cloudflare for SSL and caching, and AppSignal for application monitoring. The [web-proxy](https://github.com/Factlink/web-proxy) runs on DigitalOcean. Staging environments are set up on https://staging.factlink.com and https://staging.fct.li (proxy), and are practically identical to production.

## Licensing

Copyright (c) 2011-2014 Factlink Inc. and individual contributors. Licensed under MIT license, see [LICENSE.txt](LICENSE.txt) for the full license.
