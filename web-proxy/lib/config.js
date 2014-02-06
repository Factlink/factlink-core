/*jslint node: true*/
"use strict";

var fs = require('fs');

/**
 * Overwrites obj1's values with obj2's and adds obj2's if non existent in obj1
 * @param obj1
 * @param obj2
 * @returns obj3 a new object based on obj1 and obj2
 */
function merge_options(obj1, obj2) {
    var obj3 = {};
    var attrname, attrname2;
    for (attrname in obj1) { if (obj1.hasOwnProperty(attrname)) {obj3[attrname] = obj1[attrname]; }}
    for (attrname2 in obj2) {if (obj2.hasOwnProperty(attrname2)) {obj3[attrname2] = obj2[attrname2];}}
    return obj3;
}

var configs = {
  development: {
    FactlinkBaseUri: 'http://localhost:3000/',
    PROXY_HOSTNAME: 'localhost',
    PROXY_URL: 'http://localhost:8080/',
    INTERNAL_PROXY_PORT: 8080,
    jslib_uri: 'http://localhost:8000/lib/dist/factlink_loader_basic.js'
  },

  staging:{
    FactlinkBaseUri: 'https://factlink-staging.inverselink.com/',
    PROXY_HOSTNAME: 'staging.fct.li',
    PROXY_URL: 'http://staging.fct.li/',
    INTERNAL_PROXY_PORT: 8080,
    jslib_uri: 'https://factlink-static-staging.inverselink.com/lib/dist/factlink_loader_basic.min.js'

  },

  production:{
    FactlinkBaseUri: 'https://factlink.com/',
    PROXY_HOSTNAME: 'fct.li',
    PROXY_URL: 'http://fct.li/',
    INTERNAL_PROXY_PORT: 8080,
    jslib_uri: 'https://static.factlink.com/lib/dist/factlink_loader_basic.min.js'
  }
};

function get_config(environment){
  var env =  environment !== 'test' && environment || 'development';

  var config = configs[env];

  config.ENV = env;

  return config;
}

exports.get_config = get_config;
