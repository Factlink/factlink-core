var unencoded_url = 'http://localhost:8080/?url=http://google.com/search?as_q=baron%20bellen&factlinkModus=default';

var queryencoder = require('../lib/queryencoder');

exports['unencoded_url should contain an unencoded character'] = function(beforeExit, assert){
  beforeExit(function(){
    assert.match(unencoded_url, /&/);
  });
}

exports['encoded_search_url should not contain unencoded characters'] = function(beforeExit, assert){
  beforeExit(function(){
    assert.match(queryencoder.encoded_search_url(unencoded_url), /(?!&)/);
  });
}