/*global config:true, task:true*/

var files = {
  0: {
    directives: ["file_strip_banner"],
    files: [
      '/build/jquery-1.6.1.js',
      '/build/easyXDM/easyXDM.js',
      '/build/underscore.js'
    ]
  },
  1: {
    directives: ["file_strip_banner"],
    files: [
      '/build/jquery.scrollTo-1.4.2.js',
      '/build/jquery.hoverintent.js'
    ]
  },
  2: {
    directives: ["file_strip_banner"],
    files: [
      '/src/js/core.js'
    ]
  },
  3: {
    directives: ["file_strip_banner"],
    files: [
      '/src/js/models/fact.js',
      '/src/js/views/ballooney_thingy.js',
      '/src/js/views/balloon.js',
      '/src/js/views/prepare.js'
    ]
  },
  4: {
    directives: ["file_strip_banner"],
    files: [
      '/src/js/replace.js',
      '/src/js/annotate.js',
      '/src/js/highlight.js',
      '/src/js/scrollto.js',
      '/src/js/search.js',
      '/src/js/create.js',
      '/src/js/modal.js',
      '/src/js/lib/indicator.js'
    ]
  },
  5: {
    directives: ["file_strip_banner"],
    files: [
      '/src/js/xdm.js'
    ]
  },
  6: {
    directives: ["file_strip_banner"],
    files: [
      '/src/js/last.js'
    ]
  }
};

config.init({
  pkg: '<json:package.json>',
  meta: {
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= template.today("m/d/yyyy") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
      '* Copyright (c) <%= template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
  },
  concat: {
    'dist/factlink.js': []
  },
  min: {
    'dist/factlink.min.js': ['<banner>', 'dist/factlink.js']
  },
  qunit: {
    files: ['test/*.html', 'test/**/*.html']
  },
  lint: {
    files: ['grunt.js', 'src/js/**/*.js', 'test/**/*.js']
  },
  watch: {
    files: '<config:lint.files>',
    tasks: 'lint qunit'
  },
  jshint: {
    options: {
      "asi": false,
    	"bitwise": false,
    	"boss": false,
    	"curly": true,
    	"debug": false,
    	"eqeqeq": true,
    	"eqnull": false,
    	"evil": false,
    	"forin": false,
    	"immed": false,
    	"laxbreak": false,
    	"maxerr": 999,
    	"newcap": true,
    	"noarg": true,
    	"noempty": true,
    	"nonew": true,
    	"nomen": true,
    	"onevar": false,
    	"passfail": false,
    	"plusplus": false,
    	"regexp": true,
    	"undef": true,
    	"sub": true,
    	"strict": false,
    	"white": false
    },
    globals: {
      jQuery: true
    }
  },
  uglify: {}
});

// Default task.
task.registerTask('default', 'lint qunit concat min');