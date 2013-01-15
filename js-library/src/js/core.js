var Factlink = window.Factlink = {};

Factlink.oldWindow = window;
Factlink.global = window.parent;

// noConflicts!
jQuery.noConflict();
window.$ = function (selector,context) { return new jQuery.fn.init(selector,context || Factlink.global.document); };
$.fn = $.prototype = jQuery.fn;
jQuery.extend($, jQuery);
Factlink.$ = window.$;
Factlink._ = window._.noConflict();

if ( Factlink.global.easyXDM ) {
  Factlink.global.FACTLINK = {};
  Factlink.easyXDM = Factlink.global.FACTLINK.easyXDM = Factlink.global.easyXDM.noConflict("FACTLINK");
}

Factlink._.templateSettings = {
  interpolate : /\{%\=(.+?)%\}/g,
  evaluate : /\{%(.+?)%\}/g
};

// Create the Factlink container
Factlink.el = $('#fl');
// Create template wrapper
Factlink.tmpl = {};

// Add the stylesheet
var $style = $('<link>').attr({
  type: "text/css",
  rel: "stylesheet",
  href: FactlinkConfig.lib + "/css/basic.css?" + (new Date()).getTime()
}).prependTo($('head'));