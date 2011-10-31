/*jslint node: true*/

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

exports.read_conf = read_conf;