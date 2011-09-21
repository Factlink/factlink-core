var Factlink = window.Factlink = (function() {

  // Empty Factlink object
  var Factlink = {};

  // Function which will collect all the facts for the current page
  // and select them.
  Factlink.getTheFacts = function() {
    // The URL to the Factlink backend
    var src = window.location.protocol + '//' + FactlinkConfig.api + '/site?url=' + escape(FactlinkConfig.url !== undefined ? FactlinkConfig.url : window.location.href);

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
        // If there are multiple matches on the page, loop through them all
        for (var i = 0; i < data.length; i++) {
          //@TODO Fix the Loader
          // Update the loader
          // FL.Loader.updateStatus( "Finding matches for fact: \"" + data[i].displaystring + "\"" );
          // Select the ranges (results)
          Factlink.selectRanges(Factlink.search(data[i].displaystring), data[i]._id, data[i].score_dict_as_percentage);
        }

        var $fls = $('span.factlink').addClass('fl-active');

        setTimeout(function() {
          $fls.removeClass('fl-active');
        }, 800);

        //@TODO Fix the Loader
        // Done loading
        // FL.Loader.finish();
      }
    });
  };

  // Add the stylesheet
  var style = document.createElement("link");
  style.type = "text/css";
  style.rel = "stylesheet";
  style.href = "//" + FactlinkConfig.lib + "/src/css/basic.css?" + (new Date()).getTime();
  document.getElementsByTagName("head")[0].appendChild(style);

  // Expose the Factlink object to the global object
  return Factlink;
})();
