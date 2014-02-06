/*
 *	Factlink
 *	A simple proxy server which will proxy requests.
 *
 *	Used for implementing Factlink JavaScript on client-sites.
 */

/* jslint node: true */

config = require('./lib/config').get_config(process.env.NODE_ENV);
server = require('./lib/server').getServer(config);

server.listen(config.INTERNAL_PROXY_PORT);
console.info('\nStarted Factlink proxy on internal port ' + config.INTERNAL_PROXY_PORT);
