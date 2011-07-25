var test = {
  "JAVASCRIPT": {
    "DIST_DIR": "./dist/"
  }
};
  
test.JAVASCRIPT[process.argv[2]] = [process.argv[3]];

console.info( test );

require('smoosh').config(
    test
).build().analyze();