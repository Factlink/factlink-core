/*jslint node: true*/
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

function read_conf(config_path, fs, env) {
  var i;
  confs = ['static', 'proxy', 'core'];
  parsed_conf = {};
  for(i = 0; i < confs.length; i++) {
    // eval gives jshint issues, but this is because yaml should not use eval, not something we can fix
    file_conf = require('yaml').eval(
      fs.readFileSync(config_path+confs[i] +'.yml').toString('utf-8') + "\n\n")[env]; /* https://github.com/visionmedia/js-yaml/issues/13 */ 

    parsed_conf = merge_options(parsed_conf,file_conf);
  }
  return parsed_conf;
}

function get(process_env){
  config_path = process_env.CONFIG_PATH || '../config/';
  env         = process_env.NODE_ENV || 'testserver';

  config = read_conf(config_path, fs, env);

  config.API_URL              = config.core.protocol + config.core.hostname + ':' + config.core.port; 
  config.API_OPTIONS          = config.core.htpasswd;
  config.PROXY_URL            = config.proxy.protocol + config.proxy.hostname + ':' + config.proxy.port;
  config.STATIC_URL           = config['static'].protocol + config['static'].hostname + ':' + config['static'].port;  
  config.LIB_URL              = config.STATIC_URL + "/lib";
  config.INTERNAL_PROXY_PORT  = parseInt(config.proxy.internal_port, 10);

  return config;
}

exports.read_conf = read_conf;
exports.get = get