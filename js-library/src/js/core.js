var Factlink = window.Factlink = (function() {
  // Empty Factlink object
  var Factlink = {};

  // noConflicts!
  Factlink.$ = window.jQuery.noConflict(true);
  Factlink._ = window._.noConflict();
  Factlink.easyXDM = window.easyXDM.noConflict("FACTLINK");

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
  Factlink.el = $('<div id="fl" />').appendTo('body');
  // Create template wrapper
  Factlink.tmpl = {};

  // Add the stylesheet
  var style = document.createElement("link");
  style.type = "text/css";
  style.rel = "stylesheet";
  style.href = FactlinkConfig.lib + "/dist/css/basic.css?" + (new Date()).getTime();
  document.getElementsByTagName("head")[0].appendChild(style);
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
