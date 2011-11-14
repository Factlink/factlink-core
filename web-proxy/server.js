/*
 *	Factlink
 *	A simple proxy server which will proxy requests.
 * 
 *	Used for implementing Factlink JavaScript on client-sites.
 */

/* jslint node: true */
config_path = process.env.CONFIG_PATH || '../config/';
server = require('./lib/server').getServer(config_path);

server.listen(server.INTERNAL_PROXY_PORT);
console.info('\nStarted Factlink proxy on internal port ' + server.INTERNAL_PROXY_PORT);
