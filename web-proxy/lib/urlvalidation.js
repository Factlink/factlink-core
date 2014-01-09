/*jslint node: true*/
"use strict";

var validator = require('validator');

var protocol_regex = /^(?=.*:\/\/)/;
var http_regex = /^(?=http(s?):\/\/)/i;

function add_protocol(site){
  if (http_regex.test(site)){
    return site;
  } else if (!protocol_regex.test(site)) {
    return "http://" + site;
  } else {
    return undefined;
  }
}

function check_validity(url) {
  url = url.replace(/%[a-fA-F0-9]{2}/g, function(str){return str.toLowerCase();});
  return validator.isURL(url) ? url: undefined;
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
