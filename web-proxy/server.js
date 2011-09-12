/*
 *	Factlink
 *	A simple proxy server which will proxy requests.
 * 
 *	Used for implementing Factlink JavaScript on client-sites.
 */


// The actual server
var server = require('express').createServer();

currentEnv = process.env.NODE_ENV || 'development';



const PROXY_URL 	= "http://localhost:8080/";
const STATIC_URL 	= "http://localhost:8000/";
const PORT 				= 8080

var fs = require('fs');

// Use Jade as templating engine
server.set('view engine', 'jade');

/** 
 *	Regular get requests
 */
server.get('/parse', function(req, res) {

	console.info("\nGET /parse")

	var site = req.query.url;

	// Quick fixes for visiting sites without http
	http_regex = new RegExp("^http(s?)");
	if (http_regex.test(site) === false) {
		site = "http://" + site
	}

 	console.info("Serving: " + site);

  /**
	 *	Do the request
	 *	Restler follows redirects if needed
	 */
	var req = require('restler').get( site );

	/**
	 *	Handle response on succes
	 */
	req.on('complete', function(data) {
		// Add base url and inject proxy.js, and return the proxied site
		var html = data.replace('<head>', '<head><base href="' + site + '" />');
		html = html.replace('</head>', '<script src="' + STATIC_URL + 'proxy/scripts/proxy.js"></script></head>');

		res.write( html );
		res.end();
	});
	
	/**
	 *	Handle failed requests
	 */
	req.on("error", function(data) {
		console.error("Failed on: " + site);
		
		res.render('something_went_wrong', {
			layout: false,
			locals: {
				static_url: STATIC_URL,
				proxy_url: PROXY_URL,
				site: site
			}
		});
		
		// // Display the error page when something went wrong
		// var error_page = "<html><body><span>An error occured when trying to visit " + site + ".<br/><br/>Please check the URL or <a href='http://www.google.com/'>do a web-search</a>.</span></body></html>";
		// res.write( error_page );
		// res.end();
	});

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
	var req = require('restler').get( site, { "query": form_hash } );

	/**
	 *	Handle response on succes
	 */
	req.on('complete', function(data) {
		
		// Replace the closing head tag with a base tag
		var html = data.replace('<head>', '<head><base href="' + site + '" />');
		html = html.replace('</head>', '<script src="' + STATIC_URL + 'proxy/scripts/proxy.js?' + Number(new Date()) + '"></script></head>');

		res.write( html );
		res.end();
	});
	
	
	/**
	 *	Handle failed requests
	 */
	req.on('error', function(data) {
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