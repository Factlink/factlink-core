var Factlink = window.Factlink = (function() {
  // Empty Factlink object
  var Factlink = {};
  
  // noConflicts!
  Factlink.$ = window.jQuery.noConflict();
  Factlink._ = window._.noConflict();
  Factlink.easyXDM = window.easyXDM.noConflict("FACTLINK");
  
  Factlink._.templateSettings = {
    interpolate : /\{%\=(.+?)%\}/g,
    evaluate : /\{%(.+?)%\}/g
  };

  try {
    if ( typeof global === "undefined" && global !== window.global ) {
      global.$ = Factlink.$;
      global._ = Factlink._;
      global.easyXDM = Factlink.easyXDM;
    }
  } catch(e) { }

  // Expose the Factlink object to the global object
  return Factlink;
})();

(function(Factlink, $, _, easyXDM, undefined) {
  Factlink.siteUrl = function() {
    return FactlinkConfig.url !== undefined ? FactlinkConfig.url : window.location.href;
  };

  Factlink.Facts = [];

  // Function which will collect all the facts for the current page
  // and select them.
  Factlink.getTheFacts = function() {
    // The URL to the Factlink backend
    var src = FactlinkConfig.api + '/site?url=' + escape(Factlink.siteUrl());

    // We use the jQuery AJAX plugin
    $.ajax({
      url: src,
      dataType: "jsonp",
      crossDomain: true,
      type: "GET",
      jsonp: "callback",
      // Callback which is called when the response is loaded, will contain
      // the JSON data
      success: function(data) {
        var i;
        // If there are multiple matches on the page, loop through them all
        //TODO : dit mag pas on document ready
        
        Factlink.destroy();
        
        for (i = 0; i < data.length; i++) {
          // Select the ranges (results)
          $.merge( Factlink.Facts, Factlink.selectRanges(Factlink.search(data[i].displaystring), data[i]._id, data[i].score_dict_as_percentage) );
        }
        $(window).trigger('factlink.factsLoaded');
      }
    });
  };

  $(window).bind('factlink.libraryLoaded', function(){
    if (Factlink !== undefined && FactlinkConfig !== undefined && FactlinkConfig.getFacts === true) {
      Factlink.getTheFacts();
    }
  });

  
  Factlink.destroy = function() {
    for( var i = 0; i < Factlink.Facts.length; i++ ) {
      Factlink.Facts[i].destroy();
    }
    Factlink.Facts = [];
  };
  
  // Create the Factlink container
  Factlink.el = $('<div id="fl" />').appendTo('body');
  // Create template wrapper
  Factlink.tmpl = {};

  // Add the stylesheet
  var style = document.createElement("link");
  style.type = "text/css";
  style.rel = "stylesheet";
  style.href = FactlinkConfig.lib + "/src/css/basic.css?" + (new Date()).getTime();
  document.getElementsByTagName("head")[0].appendChild(style);
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
