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

  // Clear cookies, otherwise cookie header becomes extremely long from
  // cookies set by websites in Javascript!
  server.use(express.cookieParser());
  server.use(function (req, res, next) {
    for (var name in req.cookies) {
      // Clear both with empty domain and with hostname domain,
      // as the browser only clears when the domain matches, and
      // empty or hostname ("fct.li") are the only two possibilities
      res.clearCookie(name);
      res.clearCookie(name, {domain: config.proxy_hostname});
    }
    next();
  });

  var urlvalidation = require('./urlvalidation');

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

  /**
   * Add base url, and return the proxied site
   */
  function renderProxiedPage(res, site, original_html) {
    "use strict";

    if (/factlink_loader_publishers.min.js/.test(original_html)) {
      if (config.ENV === "development" ) {
        // Disable publisher's script in development mode
        original_html = original_html.replace(/factlink_loader_publishers.min.js/g, 'factlink_loader_publishers_DEACTIVATED.min.js');
      } else {
        res.setHeader('Cache-Control','max-age=86400');// expires in 1 day
        res.redirect(site,301);
        // Redirect to publishers' sites
        return;
      }
    }

    var output_html = original_html;

    var new_base_tag = '<base href="' + site + '" />';

    var framebuster_script = 'window.self = window.top;\n\n';

    // Inject config also at the top
    var FactlinkProxiedUri = site;

    var factlink_config_script = 'window.FactlinkProxiedUri = ' + JSON.stringify(site) + ';\n';

    var inline_setup_script_tag = '<script>' + framebuster_script +
      factlink_config_script + '</script>';

    var loader_tag = '<script async defer src="' + config.jslib_uri + '" onload="FACTLINK.proxyLoaded();"></script>';
    var header_content = new_base_tag + inline_setup_script_tag + loader_tag;

    output_html = inject_html_in_head(output_html, header_content);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(output_html);
  }

  function handleProxyRequest(res, url) {
    if ( typeof url !== "string" || url.length === 0) {
      renderWelcomePage(res);
      return;
    } else {
      var site = urlvalidation.clean_url(url);
      if (site === undefined) {
        console.error('Rendered "Something went wrong" page because of urlvalidation.clean_url on ' + url);
        renderErrorPage(res, url);
      } else {
        get(site).asString(function(err, str) {
          if(err) {
            console.error('Rendered "Something went wrong" page because could not download page on ' + url);
            renderErrorPage(res, url);
          } else {
            renderProxiedPage(res, site, str);
          }
        });
      }
    }
  }

  function renderErrorPage(res, url){
    res.render('something_went_wrong', {
      layout: false,
      locals: { site: url  }
    });
  }

  function renderWelcomePage(res){
    res.render('welcome.jade',{
      layout:false,
      locals: { core_url: config.FactlinkBaseUri }
    });
  }

  /**
   *  Inject Factlink in regular get requests
   */
  function get_parse(req, res) {
    handleProxyRequest(res, req.query.url);
  }

  return server;
}
exports.getServer = getServer;
