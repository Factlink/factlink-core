var Factlink = window.Factlink = (function() {
  // Empty Factlink object
  var Factlink = {};

  // noConflicts!
  jQuery.noConflict();
  window.$ = function (selector,context) { return new jQuery.fn.init(selector,context || window.parent.document); };
  $.fn = $.prototype = jQuery.fn;
  jQuery.extend($, jQuery);
  Factlink.$ = $;
  Factlink._ = window._.noConflict();
  if ( window.parent.easyXDM ) {
    Factlink.easyXDM = window.parent.easyXDM.noConflict("FACTLINK");
  }

  Factlink._.templateSettings = {
    interpolate : /\{%\=(.+?)%\}/g,
    evaluate : /\{%(.+?)%\}/g
  };

  // Expose the Factlink object to the global object
  return Factlink;
})();

(function(Factlink, $, _, easyXDM, undefined) {
  Factlink.siteUrl = function() {
    return FactlinkConfig.url !== undefined ? FactlinkConfig.url : window.location.href;
  };

  // Create the Factlink container
  Factlink.el = $('#fl');
  // Create template wrapper
  Factlink.tmpl = {};

  // Add the stylesheet
  var $style = $('<link>').attr({
    type: "text/css",
    rel: "stylesheet",
    href: FactlinkConfig.lib + "/dist/css/basic.css?" + (new Date()).getTime()
  }).prependTo('head');
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
