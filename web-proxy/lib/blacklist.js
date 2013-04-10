var restler       = require('restler');
var _             = require('underscore');

var API_URL,
    API_OPTIONS;
function set_API_URL(api_url) {
  API_URL = api_url;
}
function set_API_OPTIONS(api_options) {
  API_OPTIONS = api_options;
}

function if_allowed(url, successFn, errorFn) {
  var factlink_blacklist_url = API_URL + '/site/blacklisted?url=' + encodeURIComponent(url);

  var options = { parser: restler.parsers.json }

  if (API_OPTIONS !== undefined) {
    options.username = API_OPTIONS.username,
    options.password = API_OPTIONS.password
  }

  onceSuccessFn = _.once(successFn);

  restler.get(factlink_blacklist_url, options)
  .on('complete', _.once(function(data) {
    if ("blacklisted" in data) {
      errorFn();
    } else {
      onceSuccessFn();
    }
  }))
  .on('error', _.once(function(data) {
    // In case something went wrong with the call to the blacklist API,
    // allow the site.
    onceSuccessFn();
  }));
}

exports.set_API_URL = set_API_URL;
exports.set_API_OPTIONS = set_API_OPTIONS;
exports.if_allowed = if_allowed;
