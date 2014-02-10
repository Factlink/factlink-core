var config = require('../lib/config').get_config(process.env.NODE_ENV);
var server = require('../lib/server').getServer(config);

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
