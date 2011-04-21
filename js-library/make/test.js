require('smoosh').config({
  "JAVASCRIPT": {
    "DIST_DIR": "./dist/",
    "factlink": [
        // "./src/core.js",
        // "./src/create.js",
        // "./src/loader.js",
        // "./src/proxy.js",
        // "./src/replace.js",
        // "./src/search.js"
        "./dist/factlink.js"
    ]
  },
      "JSHINT_OPTS": {
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
      }
}).run();