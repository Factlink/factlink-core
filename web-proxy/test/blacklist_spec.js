var config = require('../lib/config').get(process.env);
var blacklist = require('../lib/blacklist');

blacklist.set_API_URL(config.API_URL);

exports['should call something'] = function(beforeExit, assert){
  var x = 'moi'
  register = function(){ x = 'doei'}
  blacklist.if_allowed("http://nu.nl/",register,register);
  beforeExit(function(){
    assert.equal(x,'doei');
  });
}