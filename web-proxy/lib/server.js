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
  var urlbuilder    = require('./urlbuilder');

  /**
   *  Use Jade as templating engine
   */
  server.set('view engine', 'jade');

  /**
   *  Routes and request handling
   */
  server.get('/', get_parse);
  server.get('/delayed_javascript', function(req, res) {
    setTimeout(function(){
      res.setHeader('Content-Type', 'application/javascript');
      res.send('console.log("loaded intentionally delayed script!");');
    }, parseInt(req.query.delay || "3000"));
  });

  /**
   * Static file serving in develop
   */
  if (config.ENV === 'development') {
    server.use("/static/", express.static(__dirname + "/../static/"));
  }

  // Hacky-hack to allow invalid SSL connections anyway
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

  function parse_int_or_null(variable) {
    return parseInt(variable, 10) || null;
  }

  var regex_skip_until_in_html_head =/(?:[^<]|<(?:!\s*--(?:(?!-->).)*-->|html|head|[^a-z/]))*/i;
  /* Explanation of the above regex:
   * We want to inject stuff into the <head>, but <head> may be implicit.
   * Though a <head> must officially have a <title>, omitting it doesn't break browsers, so what to detect?
   * Officially, every head needs a <title>, but invalid docs might omit it.  However, every head
   * needs *some* tag; we can just match the first tag that's not <head> or <html> - if a head really is empty, we'll match the closing </head> or <body> tags.
   *
   * Strategy: skip everything that's not a tag in the head:
   *  1. non '<' characters can be skipped; they're not interesting
   *  2. full comments <! -- comment --> can be skipped
   *  3. <head or <html can be skipped.
   *  4. <??? can be skipped when ??? isn't a closing tag so doesn't start with '/' and isn't an opening tag so doesn't start with 'a'-'z'
   * After this match we can't consume tokens and so must be at:
   * - the end of the document OR
   * - some string starting with '<' due to rule 1
   * -- BUT NOT a comment
   * -- AND NOT <html or <head
   * -- AND at a starting or closing tag.
   */

  function inject_html_in_head(page_html, fragment_to_inject) {
    "use strict";
    return page_html.replace(regex_skip_until_in_html_head, function(match) {
      return match + fragment_to_inject;
    });
  }

  function publisherUrl(site, open_id) {
    open_id = parse_int_or_null(open_id);

    if (open_id !== null) {
      return site + '#factlink-open-' + open_id;
    } else {
      return site;
    }
  }

  /**
   * Add base url, and return the proxied site
   */
  function injectFactlinkJs(original_html, site, open_id, successFn) {
    "use strict";

    if (/factlink_loader_publishers.min.js/.test(original_html)) {
      if (config.ENV === "development") {
        // Disable publisher's script in development mode
        original_html = original_html.replace(/factlink_loader_publishers.min.js/g, 'factlink_loader_publishers_DEACTIVATED.min.js');
      } else {
        // Redirect to publishers' sites
        var redirect_url = publisherUrl(site, open_id);

        successFn('<script>window.parent.location = ' + JSON.stringify(redirect_url) + ';</script>');
        return;
      }
    }

    var output_html = original_html;

    var new_base_tag = '<base href="' + site + '" />';

    var framebuster_script = 'window.self = window.top;\n\n';

    // Inject config also at the top
    var FactlinkConfig = {
      api: config.API_URL,
      lib: config.LIB_URL,
      srcPath: config.ENV === "development" ? "/factlink.core.js" : "/factlink.core.min.js",
      url: site
    };
    var factlink_config_script = 'window.FactlinkConfig = ' + JSON.stringify(FactlinkConfig) + ';\n';
    var factlink_proxy_url_script = 'window.FactlinkProxyUrl = ' + JSON.stringify(config.PROXY_URL) + ';\n';

    var inline_setup_script_tag = '<script>' + framebuster_script +
      factlink_config_script + factlink_proxy_url_script + '</script>';

    var actions = [];

    open_id = parse_int_or_null(open_id) ;

    if (open_id !== null) {
      actions.push('FACTLINK.scrollTo(' + open_id + ');');
      actions.push('FACTLINK.openFactlinkModal(' + open_id + ');');
    }

    actions.push('FACTLINK.startAnnotating();');
    actions.push('FACTLINK.showProxyMessage();');

    // Inject Factlink library at the end of the file
    var loader_filename = (config.ENV === "development" ? "/factlink_loader_basic.js" : "/factlink_loader_basic.min.js");

    var loader_tag = '<script async defer src="' + config.LIB_URL + loader_filename + '" onload="'+actions.join('')+ '"></script>';
    var header_content = new_base_tag + inline_setup_script_tag + loader_tag;

    output_html = inject_html_in_head(output_html, header_content);
    successFn(output_html);
  }

  function handleProxyRequest(res, url, open_id) {
    if ( typeof url !== "string" || url.length === 0) {
      renderWelcomePage(res);
      return;
    } else {
      site = urlvalidation.clean_url(url);
      if (site === undefined) {
        console.error('Rendered "Something went wrong" page because of urlvalidation.clean_url on ' + url);
        renderErrorPage(res, url);
      } else {
        get(site).asString(function(err, str) {
          if(err) {
            console.error('Rendered "Something went wrong" page because could not download page on ' + url);
            renderErrorPage(res, url);
          } else {
            renderProxiedPage(res, site, open_id, str);
          }
        });
      }
    }
  }

  function renderProxiedPage(res, site, open_id, html_in) {
    injectFactlinkJs(html_in, site, open_id, function(html) {
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
        core_url:       config.API_URL
      }
    });
  }

  /**
   *  Inject Factlink in regular get requests
   */
  function get_parse(req, res) {
    var site     = req.query.url;

    // TODO: remove support for scrollto next time you see this!
    var open_id  = req.query.open_id || req.query.scrollto;

    handleProxyRequest(res, site, open_id);
  }

  return server;
}
exports.getServer = getServer;
