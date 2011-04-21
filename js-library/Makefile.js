require('smoosh').config({
  "JAVASCRIPT": {
    "DIST_DIR": "./dist/",
    "factlink": [
		"./dist/factlink-tmp.js"
    ]
  }// ,
  //   "JSHINT_OPTS": {
  //     "asi": false,
  // 	"bitwise": false,
  // 	"boss": false,
  // 	"curly": true,
  // 	"debug": false,
  // 	"eqeqeq": true,
  // 	"eqnull": false,
  // 	"evil": false,
  // 	"forin": false,
  // 	"immed": true,
  // 	"laxbreak": false,
  // 	"maxerr": 999,
  // 	"newcap": true,
  // 	"noarg": true,
  // 	"noempty": true,
  // 	"nonew": true,
  // 	"nomen": true,
  // 	"onevar": true,
  // 	"passfail": false,
  // 	"plusplus": true,
  // 	"regexp": true,
  // 	"undef": true,
  // 	"sub": true,
  // 	"strict": false,
  // 	"white": false
  //   }
}).build().analyze();