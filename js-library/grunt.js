/*global config:true, task:true, underscore: true */

function createFactlinkConcatObject(filesObj) {
  return underscore.flatten(["<banner>", underscore(filesObj).map(function(fileGroup) {
    return fileGroup.map(function(file) {
      return "<file_strip_banner:" + file + ">";
    });
  })], true);
}

var files = {
  0: [
    'libs/jquery-1.6.1.js',
    'libs/easyXDM/easyXDM.js',
    'libs/underscore.js'
  ],
  1: [
    'libs/jquery.scrollTo-1.4.2.js',
    'libs/jquery.hoverintent.js'
  ],
  2: [
    'src/js/core.js'
  ],
  3: [
    'src/js/models/fact.js',
    'src/js/views/ballooney_thingy.js',
    'src/js/views/balloon.js',
    'src/js/views/prepare.js'
  ],
  4: [
    'src/js/replace.js',
    'src/js/annotate.js',
    'src/js/highlight.js',
    'src/js/scrollto.js',
    'src/js/search.js',
    'src/js/create.js',
    'src/js/modal.js',
    'src/js/lib/indicator.js'
  ],
  5: [
    'src/js/xdm.js'
  ],
  6: [
    'src/js/last.js'
  ]
};

config.init({
  pkg: '<json:package.json>',
  meta: {
    banner: '/*! \n' +
    ' * <%= pkg.title || pkg.name %> - v<%= pkg.version %> - \n' +
    '<%= pkg.homepage ? " * " + pkg.homepage + "\n" : "" %>' +
    ' *\n' +
    ' * Date: <%= template.today("m/d/yyyy") %>\n' +
    ' *\n' +
    ' * Copyright (c) <%= template.today("yyyy") %> <%= pkg.author %>;\n' +
    ' */'
  },
  concat: {
    'dist/factlink.js': createFactlinkConcatObject(files)
  },
  min: {
    'dist/factlink.min.js': ['<banner>', 'dist/factlink.js']
  },
  qunit: {
    files: ['test/*.html']
  },
  lint: {
    files: ['grunt.js', 'src/js/**/*.js', 'test/**/*.js']
  },
  watch: {
    files: '<config:lint.files>',
    tasks: 'lint qunit concat'
  },
  jshint: {
    options: {
      // Settings
      "passfail"      : false,  // Stop on first error.
      "maxerr"        : 100,    // Maximum error before stopping.


      // Predefined globals whom JSHint will ignore.
      "browser"       : true,   // Standard browser globals e.g. `window`, `document`.

      "node"          : false,
      "rhino"         : false,
      "couch"         : false,
      "wsh"           : false,   // Windows Scripting Host.

      "jquery"        : true,
      "prototypejs"   : false,
      "mootools"      : false,
      "dojo"          : false,

      "predef"        : [  // Custom globals.
        "Factlink", "FactlinkConfig", "escape"
      ],


      // Development.
      "debug"         : false,  // Allow debugger statements e.g. browser breakpoints.
      "devel"         : true,   // Allow developments statements e.g. `console.log();`.


      // ECMAScript 5.
      "es5"           : true,   // Allow ECMAScript 5 syntax.
      "strict"        : false,  // Require `use strict` pragma  in every file.
      "globalstrict"  : false,  // Allow global "use strict" (also enables 'strict').


      // The Good Parts.
      "asi"           : false,  // Tolerate Automatic Semicolon Insertion (no semicolons).
      "laxbreak"      : true,   // Tolerate unsafe line breaks e.g. `return [\n] x` without semicolons.
      "bitwise"       : true,   // Prohibit bitwise operators (&, |, ^, etc.).
      "boss"          : true,   // Tolerate assignments inside if, for & while. Usually conditions & loops are for comparison, not assignments.
      "curly"         : true,   // Require {} for every new block or scope.
      "eqeqeq"        : true,   // Require triple equals i.e. `===`.
      "eqnull"        : false,  // Tolerate use of `== null`.
      "evil"          : false,  // Tolerate use of `eval`.
      "expr"          : false,  // Tolerate `ExpressionStatement` as Programs.
      "forin"         : false,  // Tolerate `for in` loops without `hasOwnPrototype`.
      "immed"         : false,  // Require immediate invocations to be wrapped in parens e.g. `( function(){}() );`
      "latedef"       : true,   // Prohipit variable use before definition.
      "loopfunc"      : true,   // Allow functions to be defined within loops.
      "noarg"         : true,   // Prohibit use of `arguments.caller` and `arguments.callee`.
      "regexp"        : false,  // Prohibit `.` and `[^...]` in regular expressions.
      "regexdash"     : false,  // Tolerate unescaped last dash i.e. `[-...]`.
      "scripturl"     : true,   // Tolerate script-targeted URLs.
      "shadow"        : false,  // Allows re-define variables later in code e.g. `var x=1; x=2;`.
      "supernew"      : false,  // Tolerate `new function () { ... };` and `new Object;`.
      "undef"         : true,   // Require all non-global variables be declared before they are used.


      // Personal styling preferences.
      "newcap"        : true,   // Require capitalization of all constructor functions e.g. `new F()`.
      "noempty"       : true,   // Prohibit use of empty blocks.
      "nonew"         : true,   // Prohibit use of constructors for side-effects.
      "nomen"         : false,  // Prohibit use of initial or trailing underbars in names.
      "onevar"        : false,  // Allow only one `var` statement per function.
      "plusplus"      : false,  // Prohibit use of `++` & `--`.
      "sub"           : false,  // Tolerate all forms of subscript notation besides dot notation e.g. `dict['key']` instead of `dict.key`.
      "trailing"      : true,   // Prohibit trailing whitespaces.
      "white"         : false,  // Check against strict whitespace and indentation rules.
      "indent"        : 2       // Specify indentation spacing
    }
  },
  uglify: {}
});

// Default task.
task.registerTask('default', 'lint qunit concat min');