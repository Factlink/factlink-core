# global config:true, file:true, task:true, module: true

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    meta:
      banner: '/*!
       * <%= pkg.title || pkg.name %> - v<%= pkg.version %> -
       <%= pkg.homepage ? " * " + pkg.homepage : "" %>
       *
       * Date: <%= grunt.template.today("m/d/yyyy") %>
       *
       * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>;
       */'
    concat:
      wrapped_files:
        src: [
          'wrap/first.js',
          'plugins/*',
          'src/js/models/*',
          'src/js/views/*',
          'src/js/util/*',
          'src/js/initializers/*',
          'wrap/last.js'
        ]
        dest: 'tmp/factink.core.js'
      core:
        src: [
          '<banner>',
          'libs/jquery-1.7.2.js',
          'libs/underscore.js',
          'src/js/core.js',
          'tmp/factlink.core.js'
        ]
        dest: 'dist/factlink.core.js'
      loader:
        src: [
          '<banner>',
          'libs/easyXDM.js',
          'src/js/loader.js'
        ]
        dest: 'dist/factlink.js'

      'dist/factlink.start_annotating.js':   '<file_strip_banner:src/js/start_annotating.js>'
      'dist/factlink.stop_annotating.js':    '<file_strip_banner:src/js/stop_annotating.js>'
      'dist/factlink.start_highlighting.js': '<file_strip_banner:src/js/start_highlighting.js>'
      'dist/factlink.stop_highlighting.js':  '<file_strip_banner:src/js/stop_highlighting.js>'
      'dist/easyXDM/easyXDM.js':             '<file_strip_banner:libs/easyXDM.js>'
    copy:
      main:
        files: [
          { src: ['dist/css/basic.css'],          dest: 'dist/server/css/basic.css' }
          { src: ['dist/easyXDM/easyXDM.min.js'], dest: 'public/easyXDM.min.js' }
          { src: ['src/images/**'],               dest: 'dist/server/images/',      filter: 'isFile' }
          { src: ['src/images/**'],               dest: 'dist/images/',             filter: 'isFile' }
        ]
    less:
      development:
        files:
          'dist/css/basic.css': 'src/css/basic.less'
    qunit:
      all: ['test/*.html']
    watch:
      files: ['src/js/**/*', 'src/css/**/*', 'test/**/*', 'grunt.js', 'libs/**/*.js', 'plugins/**/*.js', 'wrap/*.js']
      tasks: 'jshint qunit concat less copy'
    jshint:
      all: ['grunt.js', 'src/js/**/*.js', 'test/**/*.js']
      options:
        # Whether jQuery globals should be predefined.
        jquery: true
        # Whether the standard browser globals should be predefined.
        browser: true
        # Whether logging globals should be predefined (console, alert, etc.).
        devel: true
        # Whether ES5 syntax should be allowed.
        es5: true
        # Tolerate assignments inside if, for & while. Usually conditions & loops are for comparison, not assignments.
        boss: true
        # Require {} for every new block or scope.
        curly: true
        # Require triple equals i.e. `===`.
        eqeqeq: true
        # Prohipit variable use before definition.
        latedef: true
        # Allow functions to be defined within loops.
        loopfunc: true
        # Prohibit use of `arguments.caller` and `arguments.callee`.
        noarg: true
        # Require all non-global variables be declared before they are used.
        undef: true
        # Require capitalization of all constructor functions e.g. `new F()`.
        newcap: true
        # Prohibit use of empty blocks.
        noempty: true
        # Prohibit use of constructors for side-effects.
        nonew: true
        # Custom predefined globals.
        # For value examples, see https://github.com/jshint/jshint/blob/c047ea1b01097fcc220fcd1a55c41f67ae2e6e81/jshint.js#L556
        globals:
          "Factlink": true
          "FactlinkConfig": true
          "escape": true
          "_": true
          "easyXDM": true
    uglify:
      all:
        files:
          'dist/server/factlink.core.min.js':               ['<banner>', 'dist/factlink.core.js']
          'dist/server/factlink.start_annotating.min.js':   ['<banner>', 'dist/factlink.start_annotating.js']
          'dist/server/factlink.stop_annotating.min.js':    ['<banner>', 'dist/factlink.stop_annotating.js']
          'dist/server/factlink.start_highlighting.min.js': ['<banner>', 'dist/factlink.start_highlighting.js']
          'dist/server/factlink.stop_highlighting.min.js':  ['<banner>', 'dist/factlink.stop_highlighting.js']
          'dist/server/factlink.min.js':                    ['<banner>', 'dist/factlink.js']
          'dist/server/easyXDM/easyXDM.min.js':             ['<banner>', 'dist/easyXDM/easyXDM.js']
          'dist/easyXDM/easyXDM.min.js':                    ['<banner>', 'dist/easyXDM/easyXDM.js']

  grunt.registerTask 'default', ['jshint', 'qunit', 'less', 'concat', 'uglify', 'copy']
  grunt.registerTask 'server',  ['concat', 'uglify', 'less', 'copy']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
