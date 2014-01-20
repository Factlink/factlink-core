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

```bash
$ grunt
```

This task will test and build the Factlink JavaScript library.

## Grunt

Grunt is a task-based command line build tool for JavaScript projects. It provides a few simple tasks that help with the packaging of JavaScript libraries.

### Tasks
Inside of the Factlink JavaScript Library folder, you can run a few grunt tasks:

 * **concat** - Concatenate files.
 * **lint** - Validate files with JSHint.
 * **min** - Minify files with UglifyJS.
 * **server** - Start a static web server.
 * **watch** - Run predefined tasks whenever watched files change.

Run the commands inside the js-library directory with:

```bash
$ grunt COMMAND
```

