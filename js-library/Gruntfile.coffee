# global config:true, file:true, task:true, module: true

banner_template = '/*!
* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= pkg.homepage ? " * " + pkg.homepage : "" %>
* Date: <%= grunt.template.today("m/d/yyyy") %>
* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
*/'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files: [
          {
            src: ['**/*.coffee']
            cwd: 'src/js'
            ext: '.js'
            dest: 'dist/js/'
            expand: true
          }
        ]
    concat:
      wrap:
        src: [
          'wrap/first.js',
          'plugins/*.js',
          'src/js/models/*.js',
          'tmp/compiled_coffee/models/*.js',
          'src/js/views/*.js',
          'tmp/compiled_coffee/views/*.js',
          'src/js/util/*.js',
          'tmp/compiled_coffee/util/*.js',
          'src/js/initializers/*.js',
          'tmp/compiled_coffee/initializers/*.js',
          'wrap/last.js'
        ]
        dest: 'tmp/factlink.core.js'
        ext: '.js'
      core:
        options:
          banner: banner_template
        src: [
          'libs/jquery-1.7.2.js',
          'libs/underscore.js',
          'src/js/core.js',
          'tmp/factlink.core.js'
        ]
        dest: 'dist/factlink.core.js'
      loader:
        src: [
          'libs/easyXDM.js',
          'src/js/loader.js'
        ]
        dest: 'dist/factlink.js'
    copy:
      main:
        files: [
          { src: ['dist/css/basic.css'],          dest: 'dist/server/css/basic.css' }
          { src: ['dist/easyXDM/easyXDM.min.js'], dest: 'public/easyXDM.min.js' }
          { src: ['**'],                          dest: 'dist/server/images/', expand: true, cwd: 'src/images/', filter: 'isFile' }
          { src: ['**'],                          dest: 'dist/images/',        expand: true, cwd: 'src/images/', filter: 'isFile' }
      js_files:
          {
            src: ['start_annotating.js', 'stop_annotating.js', 'start_highlighting.js', 'stop_highlighting.js']
            cwd: 'src/js/'
            expand: true
            dest: 'dist/'
            rename: (dest, src) -> "#{dest}factlink.#{src}"
          }
        ]
    less:
      development:
        files:
          'dist/css/basic.css': 'src/css/basic.less'
    qunit:
      all: ['test/*.html']
    watch:
      files: ['src/js/**/*', 'src/css/**/*', 'test/**/*', 'grunt.js', 'libs/**/*.js', 'plugins/**/*.js', 'wrap/*.js']
      tasks: ['coffee', 'jshint', 'qunit', 'concat', 'less', 'copy']
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
      options: {
        banner: banner_template
      },
      all:
        files:
          'dist/server/factlink.core.min.js':               ['dist/factlink.core.js']
          'dist/server/factlink.start_annotating.min.js':   ['dist/factlink.start_annotating.js']
          'dist/server/factlink.stop_annotating.min.js':    ['dist/factlink.stop_annotating.js']
          'dist/server/factlink.start_highlighting.min.js': ['dist/factlink.start_highlighting.js']
          'dist/server/factlink.stop_highlighting.min.js':  ['dist/factlink.stop_highlighting.js']
          'dist/server/factlink.min.js':                    ['dist/factlink.js']
          'dist/server/easyXDM/easyXDM.min.js':             ['libs/easyXDM.js']
          'dist/easyXDM/easyXDM.min.js':                    ['libs/easyXDM.js']

  grunt.registerTask 'default', ['coffee', 'jshint', 'qunit', 'less', 'concat', 'uglify', 'copy']
  grunt.registerTask 'server',  ['coffee', 'concat', 'uglify', 'less', 'copy']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
