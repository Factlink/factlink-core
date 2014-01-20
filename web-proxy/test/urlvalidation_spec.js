var urlvalidation = require('../lib/urlvalidation');

exports['test urlvalidation valid urls'] = function(beforeExit, assert){
  var urls = [
    "http://www.google.com",
    "http://www.google.com/",
    "http://google.com",
    "http://google.com/",
    "https://www.google.com",
    "https://www.google.com/",
    "https://google.com",
    "https://google.com/",
    "http://www.google.com/url?q=http"
  ];
  urls.forEach(function(url){
    assert.equal(urlvalidation.clean_url(url), url);
  });
};

exports['test urlvalidation should add missing protocol'] = function(beforeExit, assert){
  var urls = [
    "www.google.com",
    "google.com"
  ];
  urls.forEach(function(url){
    assert.equal(urlvalidation.clean_url(url), "http://" + url);
  });
};

exports['test urlvalidation should work with uri encode with uppercase characters'] = function(beforeExit, assert){
  var urls = [
  "http://duckduckgo.com/?q=%2F"
  ];
  urls.forEach(function(url){
    assert.equal(urlvalidation.add_protocol(url), url);

    assert.isDefined(urlvalidation.clean_url(url));
    assert.equal(urlvalidation.clean_url(url).toLowerCase(), url.toLowerCase());
  });
};
