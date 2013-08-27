# global config:true, file:true, task:true, module: true

banner_template = """
/*!
* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= pkg.homepage ? " * " + pkg.homepage : "" %>
* Date: <%= grunt.template.today("m/d/yyyy") %>
* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
*/
"""

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files: [
          {
            src: ['**/*.coffee']
            cwd: 'app/js'
            ext: '.js'
            dest: 'dist/js/'
            expand: true
          }
        ]
    concat:
      wrap:
        src: [
          'dist/js/wrap/first.js',
          'dist/js/plugins/*.js',
          'dist/js/models/*.js',
          'dist/js/views/*.js',
          'dist/js/util/*.js',
          'dist/js/initializers/*.js',
          'dist/js/wrap/last.js'
        ]
        dest: 'dist/wrapped.js'
      core:
        options:
          banner: banner_template
        src: [
          'dist/js/libs/jquery-1.7.2.js',
          'dist/js/core.js',
          'dist/wrapped.js'
        ]
        dest: 'dist/factlink.core.js'
      loader:
        src: [
          'dist/js/libs/easyXDM.js',
          'dist/js/loader.js'
        ]
        dest: 'dist/factlink.js'
    copy:
      main:
        files: [
          { src: ['dist/css/basic.css'], dest: 'dist/server/css/basic.css' }
          { src: ['app/robots.txt'],     dest: 'dist/server/robots.txt' }
          { src: ['**'],                 dest: 'dist/server/images/',   expand: true, cwd: 'app/images/', filter: 'isFile' }
          { src: ['**'],                 dest: 'dist/images/',          expand: true, cwd: 'app/images/', filter: 'isFile' }
        ]
      js_files:
        files: [
          { src: ['**/*.js'], dest: 'dist/js/',         expand: true, cwd: 'app/js/'}
          { src: ['app/js/libs/easyXDM.js'], dest: 'dist/easyXDM/easyXDM.min.js'}
          {
            src: ['start_annotating.js', 'stop_annotating.js', 'start_highlighting.js', 'stop_highlighting.js']
            cwd: 'app/js/'
            expand: true
            dest: 'dist/'
            rename: (dest, src) -> "#{dest}factlink.#{src}"
          }
        ]
    less:
      development:
        files:
          'dist/css/basic.css': 'app/css/basic.less'
    cssmin:
      minify:
        options:
          banner: banner_template
        expand: true,
        cwd: 'dist/css/',
        src: ['*.css'],
        dest: 'dist/server/css/'
    qunit:
      all: ['test/*.html']
    watch:
      files: ['app/js/**/*', 'app/css/**/*', 'test/**/*', 'Gruntfile.coffee']
      tasks: ['compile', 'test']
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
          'dist/server/easyXDM/easyXDM.min.js':             ['dist/js/libs/easyXDM.js']
    jshint:
      all: ['app/js/initializers/*.js', 'app/js/models/*.js', 'app/js/util/*.js', 'app/js/views/*.js', 'app/js/.js', 'test/**/*.js']
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

  grunt.registerTask 'compile', ['copy', 'coffee', 'less', 'concat']
  grunt.registerTask 'test',    ['jshint', 'qunit']

  grunt.registerTask 'default', ['compile', 'test', 'uglify']
  grunt.registerTask 'server',  ['compile', 'uglify', 'cssmin']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
