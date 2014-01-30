var config = require('../lib/config').get(process.env);
var server = require('../lib/server').getServer(config);

config_path = './config/';

development_env = {};
development_env.CONFIG_PATH = config_path;
development_env.NODE_ENV = 'development';

production_env = {};
production_env.CONFIG_PATH = config_path;
production_env.NODE_ENV = 'production';

var development_config  = require('../lib/config').get(development_env);
var production_config   = require('../lib/config').get(production_env);

/** Server */
exports['The index should render succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/',
      method: 'GET'
  }, {
      status: 200
  });
};

exports['The proxied page should be succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/?url=http://www.github.com',
      method: 'GET'
  }, {
      status: 200
  });
};

exports["When an empty url is given, the route should not throw an error"] = function(beforeExit, assert) {
  assert.response(server, {
    url: '/?url=',
    method: "GET"
  }, {
    status: 200
  });
}
