/*jslint node: true*/
"use strict";

var validator = require('validator');

function add_protocol(site){
  var protocol_regex = new RegExp("^(?=.*://)");
  var http_regex = new RegExp("^(?=http(s?)://)", "i");
  if (http_regex.test(site) === false) {
    if (protocol_regex.test(site) === false) {
      site = "http://" + site;
    } else {
      return undefined;
    }
  }
  return site;
}

function check_validity(url) {
  url = url.replace(/%[a-fA-F0-9]{2}/g, function(str){return str.toLowerCase();});
  try {
    validator.check(url, 'invalid url').isUrl();
    return url;
  } catch (e) {
    return undefined;
  }
}

function clean_url(url){
  url = add_protocol(url);
  if (url === undefined){
    return undefined;
  }
  return check_validity(url);
}

exports.add_protocol = add_protocol;
exports.check_validity = check_validity;
exports.clean_url = clean_url;
