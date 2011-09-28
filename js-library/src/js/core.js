var Factlink = window.Factlink = (function() {

  // Empty Factlink object
  var Factlink = {};

  var highlightFactlink = function( e ) { 
  var fctID = $( this ).attr( 'data-factid' ); 
  // Make sure the hover on an element works on all the paired span elements 
  $( '[data-factid=' + fctID + ']' ).addClass('fl-active');

  Factlink.Indicator.setOpinion ( 
              { 
                  percentage: $( this ).attr('data-fact-believe-percentage'), 
                  authority: $( this ).attr('data-fact-believe-authority') 
              },  
              { 
                  percentage: $( this ).attr('data-fact-doubt-percentage'), 
                  authority: $( this ).attr('data-fact-doubt-authority') 
              }, 
              { 
                  percentage: $( this ).attr('data-fact-disbelieve-percentage'), 
                  authority: $( this ).attr('data-fact-disbelieve-authority') 
              });
              Factlink.Indicator.showFor(fctID, e.pageX - 10, $(e.target).offset().top + 10 ); 
  }
  var stopHighlightingFactlink = function(e) { 
      var fctID = $( this ).attr( 'data-factid' ); 
      $( '[data-factid=' + $( this ).attr( 'data-factid' ) + ']' ).removeClass('fl-active'); 
      Factlink.Indicator.hide()
  }
  
  $( 'span.factlink' ).live( 'mouseenter', highlightFactlink)
                      .live('mouseleave', stopHighlightingFactlink );

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
        //TODO : dit mag pas on document ready
        for (var i = 0; i < data.length; i++) {
          // Select the ranges (results)
          Factlink.selectRanges(Factlink.search(data[i].displaystring), data[i]._id, data[i].score_dict_as_percentage);
        }
        $(window).trigger('factlink:factsLoaded');
        var $fls = $('span.factlink').addClass('fl-active');

        setTimeout(function() {
          $fls.removeClass('fl-active');
        }, 800);
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
