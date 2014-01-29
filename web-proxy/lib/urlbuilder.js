/*jslint node: true*/
function create_url(base, query) {
  var url;
  var key;
  url = base;
  var is_first = true;
  for (key in query) {
    if (query.hasOwnProperty(key)) {
      if (is_first === true) {
        url += '?';
        is_first = false;
      } else {
        url += '&';
      }
      url += encodeURIComponent(key);
      url += '=';
      url += encodeURIComponent(query[key]);
    }
  }
  return url;
}

exports.search_redir_url = search_redir_url;
exports.create_url = create_url;
