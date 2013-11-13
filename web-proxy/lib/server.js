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

  function publisherUrl(site, scroll_to, open_id) {
    open_id = parse_int_or_null(open_id);
    scroll_to = parse_int_or_null(scroll_to);

    if (open_id !== null) {
      return site + '#factlink-open-' + open_id;
    } else if (scroll_to !== null) {
      return site + '#factlink-' + open_id;
    } else {
      return site;
    }
  }

  /**
   * Add base url and inject proxy.js, and return the proxied site
   */
  function injectFactlinkJs(original_html, site, scroll_to, open_id, successFn) {
    "use strict";

    if (/factlink_loader_publishers.min.js/.test(original_html)) {
      // Redirect to publishers' sites
      // Circumvent blacklist as we assume we don't want to blacklist publishers for now, and it's faster
      // to not check.
      var redirect_url = publisherUrl(site, scroll_to, open_id);

      successFn('<script>window.parent.location = ' + JSON.stringify(redirect_url) + ';</script>');
      return;
    }

    blacklist.if_allowed(site,function() {

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


      var header_content = new_base_tag + '\n<script>' + framebuster_script + factlink_config_script+'</script>\n\n';

      output_html = inject_html_in_head(output_html, header_content);

      var actions = [];

      open_id = parse_int_or_null(open_id) ;
      scroll_to = parse_int_or_null(scroll_to) || open_id;

      if (open_id !== null) {
        actions.push('FACTLINK.openFactlinkModal(' + open_id + ');');
      }

      if (scroll_to !== null) {
        actions.push('FACTLINK.scrollTo(' + scroll_to + ');');
      }

      actions.push('FACTLINK.startHighlighting();');
      actions.push('FACTLINK.startAnnotating();');

      // Inject Factlink library at the end of the file
      var loader_filename = (config.ENV === "development" ? "/factlink_loader_basic.js" : "/factlink_loader_basic.min.js");

      var inject_string = '<!-- this comment is to accommodate for pages that end in an open comment! -->' +
          '<script src="' + config.LIB_URL + loader_filename + '"></script>' +
          '<script>' + actions.join('') + '</script>' +
          '<script>window.FactlinkProxyUrl = ' + JSON.stringify(config.PROXY_URL) + '</script>' +
          '<script src="' + config.PROXY_URL + '/static/scripts/proxy.js?' + Number(new Date()) + '"></script>';

      output_html += inject_string;
      successFn(output_html);
    },function(){
      successFn(original_html);
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
