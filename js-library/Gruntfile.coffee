# global config:true, file:true, task:true, module: true

banner_template = """
/*@license
* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= pkg.homepage ? " * " + pkg.homepage : "" %>
* Date: <%= grunt.template.today("m/d/yyyy") %>
* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
*
* Copyright for the annotator subcomponent:
*
* Copyright 2012 Aron Carroll, Rufus Pollock, and Nick Stenning.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
* Copyright for the jQuery subcomponent:
*
* Copyright 2013 jQuery Foundation and other contributors
* http://jquery.com/
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
        src: [
          'build/js/jail_iframe/libs/*'
          'build/js/jail_iframe/core.js'
          'build/js/jail_iframe/wrap/first.js'
          'build/js/jail_iframe/plugins/*.js'
          'build/js/jail_iframe/classes/*.js'
          'build/js/jail_iframe/util/*.js'
          'build/js/jail_iframe/initializers/*.js'
          'build/js/jail_iframe/wrap/last.js'
        ]
        dest: 'build/jail_iframe.js'
      loader_basic:
        options:
          banner: banner_template
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_basic.js'
        ]
        dest: 'build/factlink_loader_basic.js'
      loader_publishers:
        options:
          banner: banner_template
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_publishers.js'
        ]
        dest: 'build/factlink_loader_publishers.js'
      loader_bookmarklet:
        options:
          banner: banner_template
        src: [
          'build/js/loader/loader_common.js'
          'build/js/loader/loader_bookmarklet.js'
        ]
        dest: 'build/factlink_loader_bookmarklet.js'
    sass:
      build:
        options:
          bundleExec: true
          noCache: true #workaround for https://github.com/gruntjs/grunt-contrib-sass/issues/63
        files:
          'build/css/basic_without_embeds.css': 'app/css/basic.scss'
          'build/css/framed_controls_without_embeds.css': 'app/css/framed_controls.scss'
    cssUrlEmbed:
      encodeDirectly:
        files:
          'build/css/basic.css': ['build/css/basic_without_embeds.css']
          'build/css/framed_controls.css': ['build/css/framed_controls_without_embeds.css']
    cssmin:
      build:
        expand: true
        cwd: 'build/css/'
        dest: 'build/css/'
        src: '*.css'
        ext: '.min.css'
    uglify:
      options:
        preserveComments: (node, comment) -> !comment.value.lastIndexOf('@license', 0)
      jail_iframe:
        files:
          'build/jail_iframe.min.js':                        ['build/jail_iframe.js']
      all_except_jail_iframe:
        files:
          'build/factlink.start_annotating.min.js':   ['build/factlink.start_annotating.js']
          'build/factlink.stop_annotating.min.js':    ['build/factlink.stop_annotating.js']
          'build/factlink.start_highlighting.min.js': ['build/factlink.start_highlighting.js'] #Obsolete; remove 2014-04-01
          'build/factlink.stop_highlighting.min.js':  ['build/factlink.stop_highlighting.js'] #Obsolete; remove 2014-04-01
          'build/factlink_loader_basic.min.js':       ['build/factlink_loader_basic.js']
          'build/factlink_loader_publishers.min.js':  ['build/factlink_loader_publishers.js']
          'build/factlink_loader_bookmarklet.min.js': ['build/factlink_loader_bookmarklet.js']
          'build/postFactlinkObject.min.js': ['build/js/jail_iframe/util/postFactlinkObject.js']
    shell:
      gzip_js_files:
        command: ' find build/ -iname \'*.js\'  -exec bash -c \' gzip -9 -f < "{}" > "{}.gz" \' \\; '

    copy:
      build:
        files: [
          { src: ['**/*.js', '**/*.png', '**/*.gif', '**/*.woff', 'robots.txt'], cwd: 'app', dest: 'build', expand: true }
        ]
      extension_events:
        files: [
          { src: ['factlink.*.js'], cwd: 'build/js/extension_events', dest: 'build', expand: true }
        ]
      postFactlinkObject:
        files: [
          { src: ['postFactlinkObject.js'], cwd: 'build/js/jail_iframe/util', dest: 'build', expand: true }
        ]
      dist:
        files: [
          { src: ['*.js', '*.js.gz', 'robots.txt', 'images/**/*'], cwd: 'build', dest: 'output/dist', expand: true }
        ]
    watch:
      files: ['app/**/*', 'Gruntfile.coffee']
      tasks: ['default']
    mocha:
      test:
        src: ['tests/**/*.html']
        options:
          run: true

  grunt.task.registerTask 'code_inliner', 'Inline code from one file into another',  ->
    min_filename = (filename) -> filename.replace(/\.\w+$/,'.min$&')
    debug_filename = (filename) -> filename
    file_variant_funcs = [min_filename, debug_filename]
    replacements = [
      {
        placeholder: '__INLINE_CSS_PLACEHOLDER__'
        content_file: 'build/css/basic.css'
      }
      {
        placeholder: '__INLINE_FRAME_CSS_PLACEHOLDER__'
        content_file: 'build/css/framed_controls.css'
      }
      {
        placeholder: '__INLINE_JS_PLACEHOLDER__'
        content_file: 'build/jail_iframe.js'
      }
    ]
    targets = [
      'build/factlink_loader_basic.js'
      'build/factlink_loader_bookmarklet.js'
      'build/factlink_loader_publishers.js'
    ]
    file_variant_funcs.forEach (file_variant_func) ->
        replacements.forEach (replacement) ->
          input_filename = file_variant_func(replacement.content_file)
          input_content = grunt.file.read(input_filename, 'utf8')
          input_content_stringified = JSON.stringify(input_content)
          targets.map(file_variant_func).forEach (target_filename) ->
            grunt.log.writeln "Inlining '#{input_filename}' into '#{target_filename}' where  '#{replacement.placeholder}'."
            target_content = grunt.file.read target_filename, 'utf8'
            target_with_inlined_content = target_content.replace replacement.placeholder, input_content_stringified
            grunt.file.write(target_filename, target_with_inlined_content)

  grunt.registerTask 'jail_iframe', []
  grunt.registerTask 'compile',  [
    'clean', 'copy:build',  'copy:extension_events', 'coffee', 'copy:postFactlinkObject',
    'sass', 'cssUrlEmbed', 'cssmin',
    'concat', 'mocha', 'uglify', 'code_inliner',
    'shell:gzip_js_files', 'copy:dist'
  ]

  grunt.registerTask 'default', ['compile']
  grunt.registerTask 'server',  ['compile']

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-css-url-embed'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-mocha'
