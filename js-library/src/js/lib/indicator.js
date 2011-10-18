(function(Factlink, $, _, easyXDM) {
    
// Indicator object which will manage the indicator which shows some basic info  
// of each Factlink 
var template,
    $indicator = $('<div />').attr('id', 'fl-indicator').appendTo("body"); 

Factlink.Indicator = (function() { 
    // By default the element object is undefined 
    var el = $indicator, 
        // Is the indicator currently visible? 
        visible = false, 
        // This object will store the timeout id 
        timeout, 
        // Current shown Factlink 
        currentId, 
        // Position of the indication 
        x, y; 

    return { 

        getOpinions : function ( id , processOpinion) { 
          var opinions = {};
          Factlink.get("/facts/" + id + ".json" , {
           success : function(data)  {
             var dataOpinions = data.score_dict_as_percentage;
              opinions = { 'authority': dataOpinions.authority, 
                          'opinions': [ {'percentage': dataOpinions.believe.percentage, 'name' : 'believe'}, 
                                      {'percentage': dataOpinions.doubt.percentage, 'name': 'doubt'}, 
                                      {'percentage': dataOpinions.disbelieve.percentage, 'name' : 'disbelieve'} ]};
              opinions.highestOpinion =  _.max(opinions.opinions, function(op) { return op.percentage } );
              processOpinion(opinions);
           },
          });
        },

        // Makes the indicator show for the Factlink with id ID 
        showFor: function( id, x_in, y_in ) { 
            // Get the Factlink-object 
            var fl = $( 'span.factlink[data-factid=' + id + ']'); 
            var opinions = Factlink.Indicator.getOpinions(id,  function(opinions){
               
              if ( id !== currentId ) { 

                  x = x_in - 20;
                  y = y_in - el.outerHeight(true) - 10; 
              } 
            
              window.clearTimeout( timeout ); 
               
              // Store the currentId; 
              currentId = id; 
               
              // only show indicator if the user at least has the patience to hover for 10 milliseconds
              timeout = window.setTimeout(function() { 
                  if ( el === undefined ) {
                      return; 
                  } else {
                    el.css({ top: y, left: x }).html(template(opinions)).fadeIn(100);
                 }
              }, 500);  
            
          });
        }, 

        hide: function() { 
            // Make sure there isn't an timeout running 
            window.clearTimeout( timeout ); 
             
            // Put the hiding in a timeout, so it can be stopped when a user 
            // hovers the indication 
            timeout = window.setTimeout(function() { 
                el.fadeOut(100); 
                currentId = undefined; 
            }, 500); 
        }, 

        // Set the element object when it's set. 
        // Typically this will only be called from the initial ajax-call made  
        // in init.js 
        bindEvents: function( el ) { 
            var self = this; 
             
            el  .bind('mouseenter', function() { 
                    window.clearTimeout(timeout); 
                     
                    // Keep the Factlink highlighted 
                    $( '[data-factid=' + currentId + ']' ) 
                        .addClass('fl-active'); 
                }) 
                .bind('mouseleave', function() { 
                    self.hide(); 
                     
                    // Stop hightlighting the Factlink 
                    $( '[data-factid=' + currentId + ']' ) 
                        .removeClass('fl-active');
                }) 
                .bind('click', function() { 
                    self.hide(); 
                    console.info("currentid = "+currentId);
                    $( 'span.factlink[data-factid=' + currentId + ']:first').click(); 
                    return false; 
                }); 
        }
    }; 
})();

var showIndicator = function(e,factId,orig_e) {
  Factlink.Indicator.showFor(factId, orig_e.pageX - 10, $(orig_e.target).offset().top + 10); 
};

var stopShowingIndicator = function(e,factId,orig_e) {
  Factlink.Indicator.hide();
};

$(window).bind("factlink:factHighlighted", showIndicator)
         .bind("factlink:factUnhighlighted",stopShowingIndicator)
         .bind("factlink.loaded", function() { 
          $.ajax({ 
            method: 'get', 
            dataType: 'jsonp', 
            crossDomain: true, 
            url: window.location.protocol + '//' + FactlinkConfig.api + '/templates/indicator.html', 
            success: function( data ) { 
              // Factlink.Indicator.setElement( $( data ).attr('id','fl-indicator').appendTo('body') ); 
              template = _.template(data); 
              Factlink.Indicator.bindEvents($indicator);
            } 
          });
        });

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);

