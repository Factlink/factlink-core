## Core

This project is the factlink core application. Currently it consists of

* The backend
* The website
* The communication layer between the backend and the js-library

## Installation

For setting up the basic dependencies on your system, see:

https://github.com/Factlink/factlink/wiki/Setting-up-a-developer-environment

Checkout this repo.

To install system level prerequisites, run `bin/bootstrap-mac` or `bin/bootstrap-linux` (or read those files to verify you've got everything)

Then you're basically set!

You can start factlink by running

```
./start-all.sh
```

If you want more fine-grained control, the local db+bundler dependencies can be installed with `bin/bootstrap`, and the db without anything else can be started with `./start-db.sh` and the web-servers without the db or bootstrapping with `./start-web.sh`.

`./start-all.sh` avoids overheard by not running various bootstrap steps unnecessarily - to do so it compares sha1 hashes of the last executed code version with the current situation.  If every things go haywire, just delete `*.sha-cache` and everything will be re-bootstrapped.


Now open your browser and surf to http://localhost:3000

## Running the tests

`bundle exec rspec spec/unit spec; bundle exec rspec spec/acceptance spec/screenshots`

## Licensing

This project is TODO licensed, (C) Factlink
