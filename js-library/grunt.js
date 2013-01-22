/*global config:true, file:true, task:true, module: true */

module.exports = function(grunt){
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
      core: {
        src: [
          '<banner>',
          'libs/jquery-1.7.2.js',
          'libs/underscore.js',
          'src/js/core.js',
          'tmp/factlink.core.js'
        ],
        dest: 'dist/factlink.core.js'
      },
      loader: {
        src: [
          '<banner>',
          'libs/easyXDM.js',
          'src/js/loader.js'
        ],
        dest: 'dist/factlink.js'
      },
      'dist/factlink.start_annotating.js': '<file_strip_banner:src/js/start_annotating.js>',
      'dist/factlink.stop_annotating.js': '<file_strip_banner:src/js/stop_annotating.js>',
      'dist/factlink.start_highlighting.js': '<file_strip_banner:src/js/start_highlighting.js>',
      'dist/factlink.stop_highlighting.js': '<file_strip_banner:src/js/stop_highlighting.js>',
      'dist/easyXDM/easyXDM.js': '<file_strip_banner:libs/easyXDM.js>'
    },
    wrap: {
      core: {
        src: [
          'plugins/*',
          'src/js/models/*',
          'src/js/views/*',
          'src/js/util/*',
          'src/js/initializers/*'
        ],
        wrapper: [
          'wrap/first.js',
          'wrap/last.js'
        ],
        dest: 'tmp/factlink.core.js'
      }
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
      files: ['src/js/**/*', 'src/css/**/*', 'test/**/*', 'grunt.js', 'libs/**/*.js', 'plugins/**/*.js', 'wrap/*.js'],
      tasks: 'lint qunit wrap concat less copy'
    },
    jshint: {
      options: {
        // Whether jQuery globals should be predefined.
        jquery: true,
        // Whether the standard browser globals should be predefined.
        browser: true,
        // Whether logging globals should be predefined (console, alert, etc.).
        devel: true,
        // Whether ES5 syntax should be allowed.
        es5: true,
        // Tolerate assignments inside if, for & while. Usually conditions & loops are for comparison, not assignments.
        boss: true,
        // Require {} for every new block or scope.
        curly: true,
        // Require triple equals i.e. `===`.
        eqeqeq: true,
        // Prohipit variable use before definition.
        latedef: true,
        // Allow functions to be defined within loops.
        loopfunc: true,
        // Prohibit use of `arguments.caller` and `arguments.callee`.
        noarg: true,
        // Require all non-global variables be declared before they are used.
        undef: true,

        // Require capitalization of all constructor functions e.g. `new F()`.
        newcap: true,
        // Prohibit use of empty blocks.
        noempty: true,
        // Prohibit use of constructors for side-effects.
        nonew: true
      },
      // Custom predefined globals.
      // For value examples, see https://github.com/jshint/jshint/blob/c047ea1b01097fcc220fcd1a55c41f67ae2e6e81/jshint.js#L556
      globals: {
        "Factlink": true,
        "FactlinkConfig": true,
        "escape": true,
        "_": true,
        "easyXDM": true
      }
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'lint qunit less wrap concat min copy');
  grunt.registerTask('server', 'wrap concat min less copy');

  grunt.registerMultiTask('copy', 'copy files', function () {
    grunt.file.copy(this.data,this.target);
  });

  grunt.registerMultiTask('wrap', 'Wrap files with specified files', function () {
    var src = this.file.src;

    src.unshift(this.data.wrapper[0]);
    src.push(this.data.wrapper[1]);

    var files = grunt.file.expandFiles(this.file.src);

    // Concat specified files.
    var dest = grunt.helper('concat', files, {separator: this.data.separator});
    grunt.file.write(this.file.dest, dest);

    // Fail task if errors were logged.
    if (this.errorCount) { return false; }

    // Otherwise, print a success message.
    grunt.log.writeln('File "' + this.file.dest + '" created.');
  });

  grunt.loadNpmTasks('grunt-less');
};
