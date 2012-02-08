# Factlink JavaScript Library

This is the Factlink JavaScript Library that introduces Factlink's functionality on websites.

## Getting Started
Clone the [repository][repo] on your machine:

[repo]: https://github.com/Factlink/js-library

```bash
$ git clone git@github.com:Factlink/js-library.git
```

Optionaly you can choose to build from the live branch:

```bash
$ git checkout master
```

If you haven't installed grunt yet, run:

```bash
$ # (You might need to use sudo)
$ npm install grunt -g
```

When grunt is installed, to run the default task, run, inside the js-library dir:

```
$ grunt
```

This task will test and build the Factlink JavaScript library.

## FAQ

###Installing PhantomJS
**Mac OS X**

Install [Qt binary package](http://qt.nokia.com/downloads/qt-for-open-source-cpp-development-on-mac-os-x).

Get the source:

```bash
$ git clone git://github.com/ariya/phantomjs.git && cd phantomjs && git checkout 1.4.1
```

Compile:

```bash
$ qmake -spec macx-g++ && make
```

For convenience, copy the executable bin/phantomjs to some directory in your PATH. (like /usr/bin)

```bash
$ sudo cp bin/phantomjs /usr/bin/phantomjs
```

## Documentation
_(Coming soon)_

## Examples
After the Library is built, it's easy to include this library in any site.

```html
<html>
  <head>
    <title>Example page</title>
    <script src="/path/to/factlink/library/dist/factlink.js"></script>
    <script>
      function load() {
        // Highlight all Factlinks on the current page
        Factlink.startHighlighting();

        // Enter annotation mode on the current page
        Factlink.startAnnotating();
      }
    </script>
  </head>
  <body onload="load();">
    <h1>Example page</h1>
  </body>
</html>
```

## License
Copyright (c) 2012 Factlink