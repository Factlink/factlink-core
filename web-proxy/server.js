/*
 *	Factlink
 *	A simple proxy server which will proxy requests.
 * 
 *	Used for implementing Factlink JavaScript on client-sites.
 */


// The actual server
var server = require('express').createServer();
server.configure(function(){
        server.set('views', __dirname + '/views');
});

var fs = require('fs');
config_path = process.env.CONFIG_PATH || '../config/';
global.config = require('./read_config').read_conf(config_path,fs,server.settings.env);


const PROXY_URL 	= "http://"+global.config['proxy']['hostname']+':'+global.config['proxy']['port'] + "/";
const STATIC_URL 	= "http://"+global.config['static']['hostname']+':'+global.config['static']['port'] + "/";

const API_LOCATION = global.config['core']['hostname']+':'+global.config['core']['port'] + "/";
const LIB_LOCATION = global.config['static']['hostname']+':'+global.config['static']['port'] + "/lib/";


const PORT 				= parseInt(global.config['proxy']['port'],10);



// Use Jade as templating engine
server.set('view engine', 'jade');

/** 
 *	Regular get requests
 */
server.get('/parse', function(req, res) {

	console.info("\nGET /parse");

	var site = req.query.url;

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


	// Quick fixes for visiting sites without http
	protocol_regex = new RegExp("^(?=.*://)");
	http_regex = new RegExp("^(?=http(s?)://)");
	if (http_regex.test(site) === false) {
	  if (protocol_regex.test(site) === false) {
	    site = "http://" + site;
	  }else {
	    errorhandler({});
	    return;
    }
	}

 	console.info("Serving: " + site);

  /**
	 *	Do the request
	 *	Restler follows redirects if needed
	 */
	var request = require('restler').get( site );

	/**
	 *	Handle response on succes
	 */
	request.on('complete', function(data) {
		// Add base url and inject proxy.js, and return the proxied site
		var html = data.replace('<head>', '<head><base href="' + site + '" />');
		// html = html.replace('</head>', '<script src="' + STATIC_URL + 'proxy/scripts/proxy.js"></script></head>');
    set_urls = '<script>'+
               'window.FACTLINK_PROXY_URL = "' + PROXY_URL + '";'+
               'window.FACTLINK_STATIC_URL = "' + STATIC_URL + '";'+
               'window.FACTLINK_API_LOCATION = "' + API_LOCATION + '";'+
               'window.FACTLINK_LIB_LOCATION = "' + LIB_LOCATION + '";'+
               '</script>';
    load_proxy_js = '<script src="' + STATIC_URL + 'proxy/scripts/proxy.js?' + Number(new Date()) + '"></script>';
		html = html.replace('</head>', set_urls + load_proxy_js + '</head>');


		res.write( html );
		res.end();
	});

	
	/**
	 *	Handle failed requests
	 */
	request.on("error", errorhandler);

});


/** 
 * Handling forms
 * --------------
 * Forms get posted with a hidden 'factlinkPostUrl' field,
 * which is added by the proxy. This is the 'action' URL which
 * the form normally posts to.
 *
 */
server.get('/submit', function(req, res) {
	
	// factlinkPostUrl is injected in the posted form by proxy.js
	var site = req.query.factlinkPostUrl;
	console.info('Serving (as form): ' + site);

	// Set form hash and remove our temporary stored URL so we only post the original hash
	var form_hash = req.query;
	delete form_hash['factlinkPostUrl'];

  /**
	 *	Do the request and submit the form.
	 *	Restler should follow redirects if needed.
	 */
	var request = require('restler').get( site, { "query": form_hash } );

	/**
	 *	Handle response on succes
	 */
	request.on('complete', function(data) {
		
		// Replace the closing head tag with a base tag
		var html = data.replace('<head>', '<head><base href="' + site + '" />');
		html = html.replace('</head>', '<script>window.FACTLINK_PROXY_URL = "' + PROXY_URL + '";</script><script src="' + STATIC_URL + 'proxy/scripts/proxy.js?' + Number(new Date()) + '"></script></head>');

		console.log('<script>window.FACTLINK_PROXY_URL = "' + PROXY_URL + '";</script><script src="');

		res.write( html );
		res.end();
	});
	
	
	/**
	 *	Handle failed requests
	 */
	request.on('error', function(data) {
		var error_page = "<html><body><span>An error occured when trying to visit " + site + ".<br/><br/>Please check the URL or <a href='http://www.google.com/'>do a web-search</a>.<pre>form submit error</pre></span></body></html>";
		res.write( error_page );
		res.end(); 
	});	
});


/**
 *	Render the header with the url bar
 */
server.get('/header', function(req, res) {
	res.render('header', {
		layout: false,
		locals: {
			static_url: STATIC_URL,
			url: req.query.url
		}
	});
});


server.get('/', function(req, res) {
	res.render('index', {
		layout: false,
		locals: {
			proxy_url: PROXY_URL,
			url: req.query.url
		}
	});
});

server.listen(PORT);
console.info('\nStarted Factlink proxy on port ' + PORT);