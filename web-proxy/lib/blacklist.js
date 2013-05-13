var get = require('get');
var _   = require('underscore');
var url = require('url');

var API_URL,
    API_OPTIONS;

function set_API_URL(api_url) {
  API_URL = api_url;
}

function set_API_OPTIONS(api_options) {
  API_OPTIONS = api_options;
}

function if_allowed(url_to_check, notBlacklistedFn, blacklistedFn) {
  var options = {
    uri: factlink_blacklist_url(url_to_check),
    headers: factlink_blacklist_url_headers()
  };

  get(options).asString(function(err, data) {
    var json = data && JSON.parse(data);
    if (json && "blacklisted" in json) {
      blacklistedFn();
    } else {
      notBlacklistedFn();
    }
  });
}

function factlink_blacklist_url_headers() {
  var headers = {
    'Accept-Encoding': 'none',
    'Connection': 'close',
    'User-Agent': 'curl'
  };

  if (API_OPTIONS !== undefined) {
    var buffer = new Buffer(API_OPTIONS.username + ':' + API_OPTIONS.password);
    headers.Authorization = 'Basic ' + buffer.toString('base64');
  }

  return headers;
}

function factlink_blacklist_url(url_to_check) {
  var blacklist_url = url.parse(API_URL + '/site/blacklisted');

  blacklist_url.query = {
    url: url_to_check
  };

  return url.format(blacklist_url);
}

exports.set_API_URL = set_API_URL;
exports.set_API_OPTIONS = set_API_OPTIONS;
exports.if_allowed = if_allowed;
