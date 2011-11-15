var config = require('../lib/config').get(process.env);
var server = require('../lib/server').getServer(config);

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
      url: '/?url=http://www.google.com',
      method: 'GET'
  }, {
      status: 200
  });
};

exports['The proxied page should be succesful'] = function(beforeExit, assert){
  assert.response(server, {
      url: '/?url=http://www.google.com',
      method: 'GET'
  }, {
      status: 200
  });
};