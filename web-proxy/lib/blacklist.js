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

function if_allowed(url_to_check, successFn, errorFn) {
  var factlink_blacklist_url = url.parse(API_URL + '/site/blacklisted');

  factlink_blacklist_url.query = {
    'url': url_to_check
  };

  if (API_OPTIONS !== undefined) {
    factlink_blacklist_url.auth = API_OPTIONS.username + ':' + API_OPTIONS.password;
  }

  get(url.format(factlink_blacklist_url)).asString(function(err, data) {
    if (data && "blacklisted" in data) {
      errorFn();
    } else {
      successFn();
    }
  });
}

exports.set_API_URL = set_API_URL;
exports.set_API_OPTIONS = set_API_OPTIONS;
exports.if_allowed = if_allowed;
