/**
 * Overwrites obj1's values with obj2's and adds obj2's if non existent in obj1
 * @param obj1
 * @param obj2
 * @returns obj3 a new object based on obj1 and obj2
 */
function merge_options(obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname2 in obj2) { obj3[attrname2] = obj2[attrname2]; }
    return obj3;
}

function read_conf(config_path, fs, env){
confs = ['static', 'proxy', 'core'];
parsed_conf = {};
for(var i = 0; i < confs.length; i++){
  file_conf = require('yaml').eval(
      fs.readFileSync(config_path+confs[i] +'.yml').toString('utf-8') +
      "\n\n"+ /* https://github.com/visionmedia/js-yaml/issues/13 */ 
  '')[env];
  parsed_conf = merge_options(parsed_conf,file_conf);

}
return parsed_conf
}

exports.read_conf = read_conf;