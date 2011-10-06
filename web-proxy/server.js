/*
 *	Factlink
 *	A simple proxy server which will proxy requests.
 * 
 *	Used for implementing Factlink JavaScript on client-sites.
 */

/* jslint node: true */

// The actual server
var server = require('express').createServer();
server.configure(function (){
        server.set('views', __dirname + '/views');
});


/**
 *	We execute our requests using Restler
 *  because it follows redirects if needed
 */
var restler = require('restler');

var fs = require('fs');
config_path = process.env.CONFIG_PATH || '../config/';
global.config = require('./read_config').read_conf(config_path,fs,server.settings.env);


var PROXY_URL   = "http://"+global.config.proxy.hostname+':'+global.config.proxy.port;
var STATIC_URL  = "http://"+global.config['static'].hostname+':'+global.config['static'].port;

var API_LOCATION = global.config.core.hostname + ':'+global.config.core.port;
var LIB_LOCATION = global.config['static'].hostname +':'+global.config['static'].port + "/lib";

console.info(LIB_LOCATION);
console.info(STATIC_URL);

var PORT         = parseInt(global.config.proxy.port,10);


// Use Jade as templating engine
server.set('view engine', 'jade');


/**
 * Add base url and inject proxy.js, and return the proxied site
 */
function injectFactlinkJs(html_in,site, scrollto, modus){

	var html = html_in.replace(/<head[^>]*>/i, '$&<base href="' + site + '" />');
    var set_urls = '<script>'+
             'window.FACTLINK_PROXY_URL = "' + PROXY_URL + '";'+
             'window.FACTLINK_STATIC_URL = "' + STATIC_URL + '";'+
             'window.FACTLINK_API_LOCATION = "' + API_LOCATION + '";'+
             'window.FACTLINK_LIB_LOCATION = "' + LIB_LOCATION + '";'+
             'window.FACTLINK_MODUS = "' + modus + '";'+
             'window.FACTLINK_REAL_URL = "' + site + '";';
    if (scrollto !== undefined && !isNaN(parseInt(scrollto,10))){
        set_urls+='window.FACTLINK_SCROLL_TO = ' + parseInt(scrollto,10) + ';';
    }
    set_urls+='</script>';
    load_proxy_js = '<script src="' + STATIC_URL + '/proxy/scripts/proxy.js?' + Number(new Date()) + '"></script>';
	html = html.replace(/<\/head>/i, set_urls + load_proxy_js + '$&');
	return html;
}


function handleProxyRequest(res, site, scrollto, modus, form_hash){
  
  errorhandler = function(data) {
		console.error("Failed on: " + site);
		
		res.render('something_went_wrong', {
			layout: false,
			locals: {
				static_url: STATIC_URL,
				proxy_url: PROXY_URL,
				site: site
			}
		});
	};

  if (modus != "addToFact") {
    modus = "default";
  }

  // add protocol http:// if no protocol is defined:
	protocol_regex = new RegExp("^(?=.*://)");
	http_regex = new RegExp("^(?=http(s?)://)","i");
	if (http_regex.test(site) === false) {
	  if (protocol_regex.test(site) === false) {
	    site = "http://" + site;
	  }else {
	    errorhandler({});
	    return;
    }
	}

  console.info("Serving: " + site);

	var request = restler.get(site , form_hash);

	request.on('complete', function(data) {
		res.write( injectFactlinkJs(data, site, scrollto, modus) );
		res.end();
	});

	
	request.on("error", errorhandler);
}

/** 
 *	Regular get requests
 */
server.get('/parse', function(req, res) {
	console.info("\nGET /parse");
	var site = req.query.url;
  var scrollto = req.query.scrollto;
  var modus = req.query.factlinkModus;
  
  handleProxyRequest(res, site, scrollto, modus, {});
});


/** 
 * Handling forms
 * --------------
 * Forms get posted with a hidden 'factlinkFormUrl' field,
 * which is added by the proxy (in proxy.js). This is the 'action' URL which
 * the form normally submits its form to.
 *
 */
server.get('/submit', function(req, res) {
	var form_hash = req.query;

  var modus = form_hash.factlinkModus;
	delete form_hash.factlinkModus;
	
	var site = form_hash.factlinkFormUrl;
  delete form_hash.factlinkFormUrl;

  handleProxyRequest(res, site, undefined, modus, {'query':form_hash});
});


function create_url(base,query){
    var url;
    var key;
    url = base;
    var is_first = true;
    for( key in query ){
        if (query.hasOwnProperty(key)){
            if (is_first === true) {
                url += '?';
                is_first = false;
            } else {
                url += '&';
            }
            url += encodeURIComponent(key);
            url += '=';
            url += encodeURIComponent(query[key]);
        }
    }
    return url;
}

function render_page(pagename) {
  return function(req, res) {
      var header_url = create_url(PROXY_URL + "/header",req.query);
      var parse_url = create_url(PROXY_URL + "/parse",req.query);
	  res.render(pagename, {
		  layout: false,
		  locals: {
			  static_url: STATIC_URL,
			  proxy_url: PROXY_URL,
			  core_url: API_LOCATION,
			  page_url: req.query.url,
			  header_url: header_url,
			  parse_url: parse_url
		  }
	  });
  };
}

/**
 *	Render the header with the url bar
 */
server.get('/header', render_page('header'));
server.get('/', render_page('index'));

server.listen(PORT);
console.info('\nStarted Factlink proxy on port ' + PORT);