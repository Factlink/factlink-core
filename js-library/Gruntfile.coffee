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
    sass:
      build:
        files:
          'build/css/basic_without_base64.css': 'app/css/basic.scss'
    cssUrlEmbed:
      encodeDirectly:
        files:
          'build/css/basic.css': ['build/css/basic_without_base64.css']
    cssmin:
      build:
        options:
          banner: banner_template
        expand: true
        cwd: 'build/css/'
        src: ['**/*.css']
        dest: 'build/css/'
        ext: '.min.css'
    uglify:
      options: {
        banner: banner_template
      },
      jail_iframe:
        files:
          'build/jail_iframe.min.js':                        ['build/jail_iframe.js']
      all_except_jail_iframe:
        files:
          'build/factlink.start_annotating.min.js':   ['build/factlink.start_annotating.js']
          'build/factlink.stop_annotating.min.js':    ['build/factlink.stop_annotating.js']
          'build/factlink.start_highlighting.min.js': ['build/factlink.start_highlighting.js']
          'build/factlink.stop_highlighting.min.js':  ['build/factlink.stop_highlighting.js']
          'build/factlink.min.js':                    ['build/factlink.js']
          'build/factlink_loader_basic.min.js':       ['build/factlink_loader_basic.js']
          'build/factlink_loader_publishers.min.js':  ['build/factlink_loader_publishers.js']
          'build/factlink_loader_bookmarklet.min.js': ['build/factlink_loader_bookmarklet.js']
          'build/easyXDM/easyXDM.min.js':                    ['build/js/jail_iframe/libs/easyXDM.js']
    shell:
      gzip_js_files:
        command: ' find build/ -iname \'*.js\'  -exec bash -c \' gzip -9 -f < "{}" > "{}.gz" \' \\; '
      gzip_css_files:
        command: ' find build/ -iname \'*.css\'  -exec bash -c \' gzip -9 -f < "{}" > "{}.gz" \' \\; '

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
          { src: ['*.js', 'easyXDM/*.js',
                  '*.js.gz', 'easyXDM/*.js.gz',
                  '**/*.css',
                  '**/*.css.gz',
                  '**/*.png', '**/*.gif', 'robots.txt'], cwd: 'build', dest: 'dist', expand: true }
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
    code_inliner:
      loader_common:
        replacements: [
          {
            placeholder: '__INLINE_CSS_PLACEHOLDER__'
            content_file: 'build/css/basic.css'
          }
          {
            placeholder: '__INLINE_JS_PLACEHOLDER__'
            content_file: 'build/jail_iframe.js'
          }
        ]
        targets: [
          'build/factlink.js'
          'build/factlink_loader_basic.js'
          'build/factlink_loader_bookmarklet.js'
          'build/factlink_loader_publishers.js'
        ]
      basic_css:
        replacements: [
          placeholder: '__INLINE_CSS_PLACEHOLDER__'
          content_file: 'build/css/basic.css'
        ]
        targets: [
          'build/jail_iframe.js' # See jail_iframe/initializers/style.coffee
        ]


  grunt.task.registerMultiTask 'code_inliner', 'Inline code from one file into another',  ->
    min_filename = (filename) -> filename.replace(/\.\w+$/,'.min$&')
    debug_filename = (filename) -> filename
    file_variants = [min_filename, debug_filename]
    inliner = @.data

    file_variants.forEach (file_variant_func) ->
        inliner.replacements.forEach (replacement) ->
          input_filename = file_variant_func(replacement.content_file)
          input_content = grunt.file.read(input_filename, 'utf8')
          input_content_stringified = JSON.stringify(input_content)
          inliner.targets.map(file_variant_func).forEach (target_filename) ->
            grunt.log.writeln "Inlining '#{input_filename}' into '#{target_filename}' where  '#{replacement.placeholder}'."
            target_content = grunt.file.read target_filename, 'utf8'
            target_with_inlined_content = target_content.replace replacement.placeholder, input_content_stringified
            grunt.file.write(target_filename, target_with_inlined_content)

  grunt.registerTask 'jail_iframe', ['concat:jail_iframe','uglify:jail_iframe',  'code_inliner:basic_css']
  grunt.registerTask 'compile',  [
    'clean', 'copy:build', 'copy:start_stop_files', 'coffee',
    'sass', 'cssUrlEmbed', 'cssmin',
    'jail_iframe', 'concat', 'uglify:all_except_jail_iframe', 'code_inliner:loader_common'
    'shell:gzip_css_files', 'shell:gzip_js_files', 'copy:dist'
  ]
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
  grunt.loadNpmTasks 'grunt-css-url-embed'
  grunt.loadNpmTasks 'grunt-shell'
