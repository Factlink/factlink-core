/*jslint node: true*/
function encoded_search_url(url) {
  var encoded_url = encodeURIComponent(url);  
  return encoded_url;
}
exports.encoded_search_url = encoded_search_url;