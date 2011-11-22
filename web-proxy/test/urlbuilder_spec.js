var query     = "samen in Kiev";
var proxy_url = "http://proxy.factlink.com/";
var modus     = "default";

var urlbuilder = require('../lib/urlbuilder');

exports['search_redir_url should have the url parameter encoded'] = function(beforeExit, assert){
  beforeExit(function(){
    assert.match(urlbuilder.search_redir_url(proxy_url, query, modus), /url=http%3A%2F/);
  });
}

exports['search_redir_url should have the factlinkModus parameter unencoded'] = function(beforeExit, assert){
  beforeExit(function(){
    assert.match(urlbuilder.search_redir_url(proxy_url, query, modus), /&factlinkModus/);
  });
}