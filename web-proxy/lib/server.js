/* jslint node: true */
function getServer(config) {

  /**
   *  The actual server
   */
  var express = require('express');
  var server = express.createServer();
  server.configure(function() {
    server.set('views', __dirname + '/../views');
  });

  /**
   *  We execute our requests using Restler (supports redirects)
   */
  var restler       = require('restler');
  var urlvalidation = require('./urlvalidation');
  var blacklist     = require('./blacklist');
  var urlbuilder    = require('./urlbuilder');
  blacklist.set_API_URL(config.API_URL);
  blacklist.set_API_OPTIONS(config.API_OPTIONS);

  /**
   *  Use Jade as templating engine
   */
  server.set('view engine', 'jade');

  /**
   *  Routes and request handling
   */
  server.get('/',       render_page('index'));
  server.get('/header', render_page('header'));
  server.get('/unsupported', render_page('index', config.PROXY_URL + "/inner_unsupported"));
  server.get('/inner_unsupported', render_page('inner_unsupported'));
  server.get('/search', get_search);
  server.get('/parse',  get_parse);
  server.get('/submit', get_submit);

  /**
   * Static file serving in develop
   */
  if (config.ENV === 'development') {
    server.use("/static/", express.static(__dirname + "/../static/"));
  }

  /**
   * Add base url and inject proxy.js, and return the proxied site
   */
  function injectFactlinkJs(html_in, site, scrollto, modus, successFn, errorFn) {
    var FactlinkConfig = {
      modus: modus,
      api: config.API_URL,
      lib: config.LIB_URL,
      proxy: config.PROXY_URL,
      srcPath: config.ENV === "development" ? "/factlink.core.js" : "/factlink.core.min.js",
      env: config.ENV,
      url: site,
      getFacts: true
    };

    blacklist.if_allowed(site,function() {
      var html = html_in.replace(/<head[^>]*>/i, '$&<base href="' + site + '" />');

      // Inject Frame Busting Buster directly after <head>
      var fbb = '<script>window.self = window.top;</script>';
      html = html.replace(/<head?[^\>]+>/i, '$&' + fbb);

      if (scrollto !== undefined && !isNaN(parseInt(scrollto, 10))) {
        FactlinkConfig.scrollto = parseInt(scrollto, 10);
      }

      // Inject Factlink library before </head>
      var set_urls      = '<script>window.FactlinkConfig = ' + JSON.stringify(FactlinkConfig) + '</script>';
      var load_proxy_js = '<script src="' + config.PROXY_URL + '/static/scripts/proxy.js?' + Number(new Date()) + '"></script>';
      html = html.replace(/<\/head>/i, set_urls + load_proxy_js + '$&');
      successFn(html);
    },function(){
      successFn(html_in);

    });
  }

  function handleProxyRequest(res, url, scrollto, modus, form_hash) {
    var errorhandler = function(data) {
      res.render('something_went_wrong', {
        layout: false,
        locals: {
          static_url: config.STATIC_URL,
          proxy_url: config.PROXY_URL,
          site: url,
          factlinkModus : modus
        }
      });
    };

    var completehandler = function(data) {
      injectFactlinkJs(data, site, scrollto, modus, function(html) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write(html);
        res.end();
      }, function(html) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write(html);
        res.end();
      });
    };

    // Welcome page
    if ( typeof url !== "string" || url.length === 0) {
      res.render('welcome.jade',{
        layout:false,
        locals: {
          proxy_url:      config.PROXY_URL,
          core_url:       config.API_URL,
          static_url:     config.STATIC_URL,
          factlinkModus:  modus
        }
      });
      return;
    }

    modus = get_modus(modus);

    // A site is needed
    site = urlvalidation.clean_url(url);
    console.info( site );
    if (site === undefined) {
      errorhandler({});
      return;
    }

    var request = restler.get(site, form_hash);

    // Handle states
    request.on('complete',  completehandler);
    request.on('error',     errorhandler);
  }


  /**
   *  Render a jade template
   */
  function render_page(pagename, page_url) {
    return function(req, res) {
      var header_url  = urlbuilder.create_url(config.PROXY_URL + "/header", req.query);
      var parse_url   = page_url || urlbuilder.create_url(config.PROXY_URL + "/parse", req.query);
      res.render(pagename, {
        layout: false,
        locals: {
          static_url: config.STATIC_URL,
          proxy_url: config.PROXY_URL,
          core_url: config.API_URL,
          page_url: req.query.url,
          clean_page_url: urlvalidation.clean_url(req.query.url),
          factlinkModus: get_modus(req.query.factlinkModus),
          header_url: header_url,
          parse_url: parse_url
        }
      });
    };
  }


  /**
   *  Proxy modus
   */
  function get_modus(modus) {
    if (modus === undefined){
      return 'default';
    } else {
      return modus;
    }
  }

  /**
   *  Search on Factlink enabled Google
   */
  function get_search(req, res) {
    var query             = req.query.query;
    var search_redir_url  = urlbuilder.search_redir_url(config.PROXY_URL, query, get_modus(req.query.factlinkModus));

    res.redirect(search_redir_url);
  }

  /**
   *  Inject Factlink in regular get requests
   */
  function get_parse(req, res) {
    var site      = req.query.url;
    var scrollto  = req.query.scrollto;
    var modus     = get_modus(req.query.factlinkModus);

    handleProxyRequest(res, site, scrollto, modus, {});
  }

  /**
   * Forms get posted with a hidden 'factlinkFormUrl' field,
   * which is added by the proxy (in proxy.js). This is the 'action' URL which
   * the form normally submits its form to.
   */
  function get_submit(req, res) {
    var form_hash = req.query;
    var modus     = get_modus(form_hash.factlinkModus);
    delete form_hash.factlinkModus;
    var site      = form_hash.factlinkFormUrl;
    delete form_hash.factlinkFormUrl;

    handleProxyRequest(res, site, undefined, modus, {
      'query': form_hash
    });
  }

  return server;
}
exports.getServer = getServer;
