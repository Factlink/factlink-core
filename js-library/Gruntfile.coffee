# global config:true, file:true, task:true, module: true

banner_template = """
/*!
* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= pkg.homepage ? " * " + pkg.homepage : "" %>
* Date: <%= grunt.template.today("m/d/yyyy") %>
* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
*/
"""

path = require 'path'
fs = require 'fs'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean: ['build']
    coffee:
      build:
        files: [
          { src: ['**/*.coffee'], cwd: 'app', dest: 'build', ext: '.js', expand: true }
        ]
    concat:
      jail_iframe:
        options:
          banner: banner_template
        src: [
          'build/js/jail_iframe/libs/jquery-1.7.2.js'
          'build/js/jail_iframe/core.js'
          'build/js/jail_iframe/wrap/first.js'
          'build/js/jail_iframe/libs/easyXDM.js'
          'build/js/jail_iframe/plugins/*.js'
          'build/js/jail_iframe/classes/*.js'
          'build/js/jail_iframe/views/*.js'
          'build/js/jail_iframe/util/*.js'
          'build/js/jail_iframe/initializers/*.js'
          'build/js/jail_iframe/wrap/last.js'
        ]
        dest: 'build/jail_iframe.js'
      loader_DEPRECATED:
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_basic.js'
        ]
        dest: 'build/factlink.js'
      loader_basic:
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_basic.js'
        ]
        dest: 'build/factlink_loader_basic.js'
      loader_publishers:
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_publishers.js'
        ]
        dest: 'build/factlink_loader_publishers.js'
      loader_bookmarklet:
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_bookmarklet.js'
        ]
        dest: 'build/factlink_loader_bookmarklet.js'
      publisher:
        src:  'build/js/publisher_poc/nu.js'
        dest: 'build/nu.js'
    code_inliner:
      jail_iframe_loader_DEPRECATED:
        src: 'build/jail_iframe.js'
        dest: 'build/factlink.js'
      jail_iframe_loader_basic:
        src: 'build/jail_iframe.js'
        dest: 'build/factlink_loader_basic.js'
      jail_iframe_loader_publishers:
        src: 'build/jail_iframe.js'
        dest: 'build/factlink_loader_publishers.js'
      jail_iframe_loader_bookmarklet:
        src: 'build/jail_iframe.js'
        dest: 'build/factlink_loader_bookmarklet.js'

      jail_iframe_loader_DEPRECATED_min:
        src: 'build/jail_iframe.min.js'
        dest: 'build/server/factlink.min.js'
      jail_iframe_loader_basic_min:
        src: 'build/jail_iframe.min.js'
        dest: 'build/server/factlink_loader_basic.min.js'
      jail_iframe_loader_publishers_min:
        src: 'build/jail_iframe.min.js'
        dest: 'build/server/factlink_loader_publishers.min.js'
      jail_iframe_loader_bookmarklet_min:
        src: 'build/jail_iframe.min.js'
        dest: 'build/server/factlink_loader_bookmarklet.min.js'
    sass:
      build:
        files:
          'build/css/basic.css': 'app/css/basic.scss'
          'build/css/publisher_poc/nu.nl.css': 'app/css/publisher_poc/nu.nl.scss'
    cssmin:
      build:
        options:
          banner: banner_template
        expand: true
        cwd: 'build/css/'
        src: ['**/*.css']
        dest: 'build/server/css/'
    uglify:
      options: {
        banner: banner_template
      },
      all:
        files:
          'build/jail_iframe.min.js':                        ['build/jail_iframe.js']
          'build/server/factlink.start_annotating.min.js':   ['build/factlink.start_annotating.js']
          'build/server/factlink.stop_annotating.min.js':    ['build/factlink.stop_annotating.js']
          'build/server/factlink.start_highlighting.min.js': ['build/factlink.start_highlighting.js']
          'build/server/factlink.stop_highlighting.min.js':  ['build/factlink.stop_highlighting.js']
          'build/server/factlink.min.js':                    ['build/factlink.js']
          'build/server/factlink_loader_basic.min.js':       ['build/factlink_loader_basic.js']
          'build/server/factlink_loader_publishers.min.js':  ['build/factlink_loader_publishers.js']
          'build/server/factlink_loader_bookmarklet.min.js': ['build/factlink_loader_bookmarklet.js']
          'build/server/easyXDM/easyXDM.min.js':             ['build/js/jail_iframe/libs/easyXDM.js']
          'build/easyXDM/easyXDM.min.js':                    ['build/js/jail_iframe/libs/easyXDM.js']
          'build/server/nu.min.js':                          ['build/nu.js']
    copy:
      build:
        files: [
          { src: ['**/*.js', '**/*.png', '**/*.gif', 'robots.txt'], cwd: 'app', dest: 'build', expand: true }
        ]
      start_stop_files:
        files: [
          { src: ['factlink.*.js'], cwd: 'build/js', dest: 'build', expand: true }
        ]
      dist:
        files: [
          { src: ['*.js', 'server/**/*.js', 'easyXDM/*.js', '**/*.css', '**/*.png', '**/*.gif', 'robots.txt'], cwd: 'build', dest: 'dist', expand: true }
          { src: ['**/*.png', '**/*.gif', 'robots.txt'], cwd: 'build', dest: 'dist/server', expand: true }
        ]
    watch:
      files: ['app/js/**/*', 'app/css/**/*', 'test/**/*', 'Gruntfile.coffee']
      tasks: ['compile', 'test']
    qunit:
      all: ['test/*.html']
    jshint:
      all: ['app/js/jail_iframe/util/*.js', 'test/**/*.js']
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

  grunt.task.registerMultiTask 'code_inliner', 'Inline code from one file into another', ->
    @files.forEach (f) ->
      source_file_path = f.src
      destination_file_path = f.dest

      grunt.log.writeln "Inlining code from '#{source_file_path}' to '#{destination_file_path}'."

      stringified_source_code = JSON.stringify(grunt.file.read(source_file_path, 'utf8'))
      destination_code = grunt.file.read destination_file_path, 'utf8'
      destination_code_with_inlined_source = destination_code.replace /__INLINE_CODE_FROM_GRUNT__/, stringified_source_code

      grunt.file.write destination_file_path, destination_code_with_inlined_source

  grunt.registerTask 'compile', ['clean', 'copy:build', 'copy:start_stop_files',
                                 'coffee', 'sass', 'concat', 'uglify', 'cssmin',
                                 'code_inliner', 'copy:dist']
  grunt.registerTask 'test',    ['jshint', 'qunit']

  grunt.registerTask 'default', ['compile', 'test']
  grunt.registerTask 'server',  ['compile']

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-clean'
