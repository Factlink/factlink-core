var restler       = require('restler');

var API_URL;
function set_API_URL(api_url){
  API_URL = api_url;
}

function if_allowed(url, successFn, errorFn) {
  var factlink_blacklist_url = API_URL + '/sites/' + encodeURIComponent(url) + '/info';
  console.log(factlink_blacklist_url)
  restler.get(factlink_blacklist_url, 
    {parser:restler.parsers.json,
      username: 'proxyuser',
      password: 'proxypass'
  })
  .on('complete', function(data) {
    if (data.blacklisted !== true) {
      successFn();
    } else {
      errorFn();
    }
  })
  .on('error', function(data) {
    console.log("BARON CHERE DE LA PROBLEMOS!");
    // TODO: What should happen when a call to the blacklist API fails?
    succesFn();
  });
}

exports.set_API_URL = set_API_URL;
exports.if_allowed = if_allowed;
