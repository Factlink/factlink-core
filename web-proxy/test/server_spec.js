var config = require('../lib/config').get(process.env);
var server = require('../lib/server').getServer(config);

config_path = process.env.CONFIG_PATH || '../config/';

testserver_env = {};
testserver_env.CONFIG_PATH = config_path;
testserver_env.NODE_ENV = 'testserver';

development_env = {};
development_env.CONFIG_PATH = config_path;
development_env.NODE_ENV = 'development';

production_env = {};
production_env.CONFIG_PATH = config_path;
production_env.NODE_ENV = 'production';


var testserver_config   = require('../lib/config').get(testserver_env);
var development_config  = require('../lib/config').get(development_env);
var production_config   = require('../lib/config').get(production_env);

/** Config */
exports['htpasswd should NOT be set on development env'] = function(beforeExit, assert){
  assert.isUndefined(development_config.core.htpasswd);
};
exports['htpasswd should be set on testserver env'] = function(beforeExit, assert){
  assert.eql(testserver_config.core.htpasswd.username, "proxyuser");
};
exports['htpasswd should be set on production env'] = function(beforeExit, assert){
  assert.eql(production_config.core.htpasswd.username, "proxyuser");
};

/** Server */
exports['The index should render succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/',
      method: 'GET'
  }, {
      status: 200
  });
};
exports['The header should render'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/header',
      method: 'GET'
  }, {
      status: 200
  });
};

exports['The proxied page should be succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/parse?url=http://www.github.com',
      method: 'GET'
  }, {
      status: 200
  });
};

exports['The proxied page should be succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/parse?url=http://www.github.com',
      method: 'GET'
  }, {
      status: 200
  });
};

exports["When an empty url is given, the route should not throw an error"] = function(beforeExit, assert) {
  assert.response(server, {
    url: '/parse?url=',
    method: "GET"
  }, {
    status: 200
  });
}