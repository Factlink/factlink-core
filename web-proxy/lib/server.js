/* jslint node: true */

var _   = require('underscore');
var get = require('get');

function getServer(config) {

  /**
   *  The actual server
   */
  var express = require('express');
  var server = express.createServer();
  server.configure(function() {
    server.set('views', __dirname + '/../views');
  });

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

  function parse_int_or_null(variable) {
    return parseInt(variable, 10) || null;
  }

  /**
   * Add base url and inject proxy.js, and return the proxied site
   */
  function injectFactlinkJs(html_in, site, scrollto, open_id, successFn) {
    var FactlinkConfig = {
      api: config.API_URL,
      lib: config.LIB_URL,
      srcPath: config.ENV === "development" ? "/factlink.core.js" : "/factlink.core.min.js",
      url: site
    };

    blacklist.if_allowed(site,function() {
      var html = html_in.replace(/<head[^>]*>/i, '$&<base href="' + site + '" />');

      // Inject Frame Busting Buster directly after <head>
      var fbb = '<script>window.self = window.top;</script>';
      html = html.replace(/<head?[^\>]+>/i, '$&' + fbb);

      var actions = [];

      open_id = parse_int_or_null(open_id) ;
      scrollto = parse_int_or_null(scrollto) || open_id;

      if (open_id !== null) {
        actions.push('FACTLINK.on("factlink.factsLoaded", function() { FACTLINK.openFactlinkModal(' + open_id + '); });');
      }

      if (scrollto !== null) {
        actions.push('FACTLINK.on("factlink.factsLoaded", function() { FACTLINK.scrollTo(' + scrollto + '); });');
      }

      // Call after binding to event, as this might trigger event
      actions.push('FACTLINK.startHighlighting();');
      actions.push('FACTLINK.startAnnotating();');

      // Inject Factlink library at the end of the file
      var loader_filename = (config.ENV === "development" ? "/factlink_loader_basic.js" : "/factlink_loader_basic.min.js");

      var inject_string = '<!-- this comment is to accommodate for pages that end in an open comment! -->' +
                          '<script>window.FactlinkConfig = ' + JSON.stringify(FactlinkConfig) + '</script>' +
                          '<script src="' + config.LIB_URL + loader_filename + '"></script>' +
                          '<script>' + actions.join('') + '</script>' +
                          '<script>window.FactlinkProxyUrl = ' + JSON.stringify(config.PROXY_URL) + '</script>' +
                          '<script src="' + config.PROXY_URL + '/static/scripts/proxy.js?' + Number(new Date()) + '"></script>';

      successFn(html + inject_string);
    },function(){
      successFn(html_in);
    });
  }

  function handleProxyRequest(res, url, scrollto, open_id, form_hash) {
    if ( typeof url !== "string" || url.length === 0) {
      renderWelcomePage(res);
      return;
    } else {
      site = urlvalidation.clean_url(url);
      if (site === undefined) {
        renderErrorPage(res, url);
      } else {
        get(site).asString(function(err, str) {
          if(err) {
            renderErrorPage(res, url);
          } else {
            renderProxiedPage(res, site, scrollto, open_id, str);
          }
        });
      }
    }
  }

  function renderProxiedPage(res, site, scrollto, open_id, html_in) {
    injectFactlinkJs(html_in, site, scrollto, open_id, function(html) {
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(html);
      res.end();
    });
  }

  function renderErrorPage(res, url){
    res.render('something_went_wrong', {
      layout: false,
      locals: {
        static_url: config.STATIC_URL,
        proxy_url: config.PROXY_URL,
        site: url
      }
    });
  }

  function renderWelcomePage(res){
    res.render('welcome.jade',{
      layout:false,
      locals: {
        proxy_url:      config.PROXY_URL,
        core_url:       config.API_URL,
        static_url:     config.STATIC_URL
      }
    });
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
          factlinkModus: req.query.factlinkModus,
          header_url: header_url,
          parse_url: parse_url
        }
      });
    };
  }

  /**
   *  Search on Factlink enabled Google
   */
  function get_search(req, res) {
    var query             = req.query.query;
    var search_redir_url  = urlbuilder.search_redir_url(config.PROXY_URL, query, req.query.factlinkModus);

    res.redirect(search_redir_url);
  }

  /**
   *  Inject Factlink in regular get requests
   */
  function get_parse(req, res) {
    var site     = req.query.url;
    var scrollto = req.query.scrollto;
    var open_id  = req.query.open_id;
    handleProxyRequest(res, site, scrollto, open_id, {});
  }

  /**
   * Forms get posted with a hidden 'factlinkFormUrl' field,
   * which is added by the proxy (in proxy.js). This is the 'action' URL which
   * the form normally submits its form to.
   */
  function get_submit(req, res) {
    var form_hash = req.query;
    var site      = form_hash.factlinkFormUrl;
    delete form_hash.factlinkFormUrl;

    handleProxyRequest(res, site, undefined, undefined, {
      'query': form_hash
    });
  }

  return server;
}
exports.getServer = getServer;
