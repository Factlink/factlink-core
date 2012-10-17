/*global config:true, file:true, task:true, module: true */

var files = {
  0: [
    'libs/jquery-1.7.2.js',
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
    'src/js/events.js',
    'src/js/models/fact.js',
    'src/js/views/set_position_of_element.js',
    'src/js/views/balloon.js',
    'src/js/views/prepare.js'
  ],
  4: [
    'src/js/replace.js',
    'src/js/annotate.js',
    'src/js/highlight.js',
    'src/js/scrollto.js',
    'src/js/loaded_message.js',
    'src/js/search.js',
    'src/js/create.js',
    'src/js/modal.js',
    'src/js/extension.js',
    'src/js/views/templates.js',
    'src/js/initialize.js'
  ],
  5: [
    'src/js/xdm.js'
  ],
  6: [
    'src/js/last.js'
  ]
};

var loaderFiles = {
  0: [
    'libs/easyXDM.js'
  ],
  1: [
    'src/js/loader.js'
  ]
};

module.exports = function(grunt){

  function createFactlinkConcatObject(filesObj) {
    return grunt.utils._.flatten(["<banner>", grunt.utils._(filesObj).map(function(fileGroup) {
      return fileGroup.map(function(file) {
        return "<file_strip_banner:" + file + ">";
      });
    })], true);
  }

  grunt.initConfig({
    pkg: '<json:package.json>',
    meta: {
      banner: '/*! \n' +
      ' * <%= pkg.title || pkg.name %> - v<%= pkg.version %> - \n' +
      '<%= pkg.homepage ? " * " + pkg.homepage + "\n" : "" %>' +
      ' *\n' +
      ' * Date: <%= grunt.template.today("m/d/yyyy") %>\n' +
      ' *\n' +
      ' * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>;\n' +
      ' */'
    },
    concat: {
      'dist/factlink.core.js': createFactlinkConcatObject(files),
      'dist/factlink.start_annotating.js': '<file_strip_banner:src/js/start_annotating.js>',
      'dist/factlink.stop_annotating.js': '<file_strip_banner:src/js/stop_annotating.js>',
      'dist/factlink.start_highlighting.js': '<file_strip_banner:src/js/start_highlighting.js>',
      'dist/factlink.stop_highlighting.js': '<file_strip_banner:src/js/stop_highlighting.js>',
      'dist/easyXDM/easyXDM.js': '<file_strip_banner:libs/easyXDM.js>',
      'dist/factlink.js': createFactlinkConcatObject(loaderFiles)
    },
    copy: {
      'dist/server/css/basic.css': 'dist/css/basic.css',

      'public/easyXDM.min.js': 'dist/easyXDM/easyXDM.min.js',

      'dist/server/images/arrows-bottom.png':     'src/images/arrows-bottom.png',
      'dist/server/images/arrows-top.png':        'src/images/arrows-top.png',
      'dist/server/images/bookmark.gif':          'src/images/bookmark.gif',
      'dist/server/images/loading-indicator.gif': 'src/images/loading-indicator.gif',
      'dist/server/images/logo-small.png':        'src/images/logo-small.png',
      'dist/server/images/logo-white.png':        'src/images/logo-white.png',

      'dist/images/arrow.png':                'src/images/arrow.png',
      'dist/images/arrows-bottom.png':        'src/images/arrows-bottom.png',
      'dist/images/arrows-top.png':           'src/images/arrows-top.png',
      'dist/images/bookmark.gif':             'src/images/bookmark.gif',
      'dist/images/loading-indicator.gif':    'src/images/loading-indicator.gif',
      'dist/images/logo-small.png':           'src/images/logo-small.png',
      'dist/images/logo-white.png':           'src/images/logo-white.png'
    },
    less: {
      basic: {
        src: 'src/css/basic.less',
        dest: 'dist/css/basic.css',
        options: {
          yuicompress: true
        }
      }
    },
    min: {
      'dist/server/factlink.core.min.js': ['<banner>', 'dist/factlink.core.js'],
      'dist/server/factlink.start_annotating.min.js': ['<banner>', 'dist/factlink.start_annotating.js'],
      'dist/server/factlink.stop_annotating.min.js': ['<banner>', 'dist/factlink.stop_annotating.js'],
      'dist/server/factlink.start_highlighting.min.js': ['<banner>', 'dist/factlink.start_highlighting.js'],
      'dist/server/factlink.stop_highlighting.min.js': ['<banner>', 'dist/factlink.stop_highlighting.js'],
      'dist/server/factlink.min.js': ['<banner>', 'dist/factlink.js'],
      'dist/server/easyXDM/easyXDM.min.js': ['<banner>', 'dist/easyXDM/easyXDM.js'], // for the server
      'dist/easyXDM/easyXDM.min.js': ['<banner>', 'dist/easyXDM/easyXDM.js']        // for local
    },
    qunit: {
      files: ['test/*.html']
    },
    lint: {
      files: ['grunt.js', 'src/js/**/*.js', 'test/**/*.js']
    },
    watch: {
      files: ['src/js/**/*', 'src/css/**/*', 'test/**/*', 'grunt.js'],
      tasks: 'lint qunit concat less copy'
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
  grunt.registerTask('default', 'lint qunit less concat min copy');
  grunt.registerTask('server', 'concat min less copy');

  grunt.registerMultiTask('copy', 'copy files', function () {
    grunt.file.copy(this.data,this.target);
  });

  grunt.loadNpmTasks('grunt-less');
};
