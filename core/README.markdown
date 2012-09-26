## Core

This project is the factlink core application. Currently it consists of

* The backend
* The website
* The communication layer between the backend and the js-library

## Installation

For setting up the basic dependencies on your system, see:

https://github.com/Factlink/core/wiki/Setting-up-a-developer-environment

Now to setup factlink, go to your projectdir, and save the following script there:
https://github.com/Factlink/core/blob/develop/script/setup_env.sh

Now run the script:

```
sh setup_env.sh
```

Now run the factlinkapps by running foreman

```
foreman start -f ProcfileServers
foreman start
```

Now open your browser and surf to http://localhost:3000

## Running the tests

The first time you need to install soundcheck

```
gem install soundcheck --pre
```

After that, simply do the following (from the base dir):

```
cd core
soundcheck
```

## Licensing

This project is closed source, (C) Factlink
