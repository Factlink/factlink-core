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
  get(factlink_blacklist_url()).asString(function(err, data) {
    if (data && "blacklisted" in data) {
      blacklistedFn();
    } else {
      notBlacklistedFn();
    }
  });
}

function factlink_blacklist_url(url_to_check) {
  var blacklist_url = url.parse(API_URL + '/site/blacklisted');

  blacklist_url.query = {
    url: url_to_check
  };

  if (API_OPTIONS !== undefined) {
    blacklist_url.auth = API_OPTIONS.username + ':' + API_OPTIONS.password;
  }

  return url.format(blacklist_url);
}

exports.set_API_URL = set_API_URL;
exports.set_API_OPTIONS = set_API_OPTIONS;
exports.if_allowed = if_allowed;
