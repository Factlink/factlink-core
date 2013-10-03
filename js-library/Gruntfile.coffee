# global config:true, file:true, task:true, module: true

banner_template = """
/*!
* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= pkg.homepage ? " * " + pkg.homepage : "" %>
* Date: <%= grunt.template.today("m/d/yyyy") %>
* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
*/
"""

crypto = require 'crypto'
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
    corehasher:
      src: 'build/server/factlink.core.min.js'
      dest: 'build/js/loader/loader_common.js'
    concat:
      core:
        options:
          banner: banner_template
        src: [
          'build/js/libs/jquery-1.7.2.js'
          'build/js/core.js'
          'build/js/wrap/first.js'
          'build/js/plugins/*.js'
          'build/js/classes/*.js'
          'build/js/views/*.js'
          'build/js/util/*.js'
          'build/js/initializers/*.js'
          'build/js/wrap/last.js'
        ]
        dest: 'build/factlink.core.js'
      loader_DEPRECATED:
        src: [
          'build/js/libs/easyXDM.js'
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_basic.js'
        ]
        dest: 'build/factlink.js'
      loader_basic:
        src: [
          'build/js/libs/easyXDM.js'
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_basic.js'
        ]
        dest: 'build/factlink_loader_basic.js'
      loader_publishers:
        src: [
          'build/js/libs/easyXDM.js'
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_publishers.js'
        ]
        dest: 'build/factlink_loader_publishers.js'
      loader_bookmarklet:
        src: [
          'build/js/libs/easyXDM.js'
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_bookmarklet.js'
        ]
        dest: 'build/factlink_loader_bookmarklet.js'
      publisher:
        src:  'build/js/publisher_poc/nu.js'
        dest: 'build/nu.js'
    less:
      build:
        files:
          'build/css/basic.css': 'app/css/basic.less'
          'build/css/publisher_poc/nu.nl.css': 'app/css/publisher_poc/nu.nl.less'
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
      core:
        files:
          'build/server/factlink.core.min.js':               ['build/factlink.core.js']
      all_except_core:
        files:
          'build/server/factlink.start_annotating.min.js':   ['build/factlink.start_annotating.js']
          'build/server/factlink.stop_annotating.min.js':    ['build/factlink.stop_annotating.js']
          'build/server/factlink.start_highlighting.min.js': ['build/factlink.start_highlighting.js']
          'build/server/factlink.stop_highlighting.min.js':  ['build/factlink.stop_highlighting.js']
          'build/server/factlink.min.js':                    ['build/factlink.js']
          'build/server/factlink_loader_basic.min.js':       ['build/factlink_loader_basic.js']
          'build/server/factlink_loader_publishers.min.js':  ['build/factlink_loader_publishers.js']
          'build/server/factlink_loader_bookmarklet.min.js': ['build/factlink_loader_bookmarklet.js']
          'build/server/easyXDM/easyXDM.min.js':             ['build/js/libs/easyXDM.js']
          'build/easyXDM/easyXDM.min.js':                    ['build/js/libs/easyXDM.js']
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
      all: ['app/js/initializers/*.js', 'app/js/classes/*.js', 'app/js/util/*.js', 'app/js/views/*.js', 'app/js/.js', 'test/**/*.js']
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

  md5 = (filepath) ->
    hash = crypto.createHash 'md5'
    hash.update grunt.file.read filepath, 'utf8'
    hash.digest 'hex'

  grunt.task.registerTask 'corehasher', 'Load FactlinkCore with a hash.', ()->
    source_file_path = grunt.config 'corehasher.src'
    destination_file_path = grunt.config 'corehasher.dest'
    grunt.log.writeln "Calculating hash from file \"#{source_file_path}\""
    source_file_hash = md5 source_file_path

    new_source_file_path = source_file_path.replace /.js$/, '.'+source_file_hash+'.js'
    grunt.log.writeln "Renaming file \"#{source_file_path}\" to \"#{new_source_file_path}\""
    fs.renameSync(source_file_path, new_source_file_path );

    grunt.log.writeln "Replacing placeholder with hash value in file \"#{destination_file_path}\"."
    content = grunt.file.read destination_file_path
    content_with_hash = content.replace /&\*HASH_PLACE_HOLDER\*&/, source_file_hash
    grunt.file.write destination_file_path, content_with_hash

  grunt.registerTask 'core', ['concat:core', 'uglify:core', 'corehasher']
  grunt.registerTask 'compile', ['clean', 'copy:build', 'coffee', 'less', 'core', 'concat', 'copy:start_stop_files',
                                 'uglify:all_except_core', 'cssmin', 'copy:dist']
  grunt.registerTask 'test',    ['jshint', 'qunit']

  grunt.registerTask 'default', ['compile', 'test']
  grunt.registerTask 'server',  ['compile']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-clean'
