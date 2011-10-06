(function(Factlink, $, _, easyXDM) {
    
    // Indicator object which will manage the indicator which shows some basic info  
// of each Factlink 
Factlink.Indicator = (function() { 
    // By default the element object is undefined 
    var el, 
        // Is the indicator currently visible? 
        visible = false, 
        // This object will store the timeout id 
        timeout, 
        // Current shown Factlink 
        currentId, 
        // Position of the indication 
        x, y; 
     
    return { 
        // Makes the indicator show for the Factlink with id ID 
        showFor: function( id, x_in, y_in) { 
            // Get the Factlink-object 
            var fl = $( 'span.factlink[data-factid=' + id + ']'); 
             
            believe_percentage = fl.first().data('fact-believe-percentage');
            disbelieve_percentage = fl.first().data('fact-disbelieve-percentage');
            doubt_percentage = fl.first().data('fact-doubt-percentage');
            authority = fl.first().data('fact-authority');
            // On creation of a new Fact, authority is undefined. Fall to default
            if ( authority === 'undefined' ) {
              authority = 0;
            }
            
            prevalent = 'doubt';
            prevalent_percentage = doubt_percentage;
            
            if (disbelieve_percentage > prevalent_percentage){
                prevalent = 'disbelieve';
                prevalent_percentage = disbelieve_percentage;
            }
            if (believe_percentage > prevalent_percentage){
                prevalent = 'believe';
                prevalent_percentage = believe_percentage;
            }
            
            if ( id !== currentId ) { 
                x = x_in + 10;
                y = y_in - el.outerHeight(true) - 10; 
            } 
 
            window.clearTimeout( timeout ); 
             
            // Store the currentId; 
            currentId = id; 
             
            // only show indicator if the user at least has the patience to hover for 10 milliseconds
            timeout = window.setTimeout(function(){ 
                if ( el === undefined ) {
                    return; 
                } else {
                  el.find('div.believe, div.disbelieve, div.doubt').hide();
                  el.find('div.'+prevalent).show();
                  el.find('span.authority').html(authority);
                  el.css({ top: y, left: x }).fadeIn(100);
               }
            }, 500); 
        }, 

        hide: function() { 
            // Make sure there isn't an timeout running 
            window.clearTimeout( timeout ); 
             
            // Put the hiding in a timeout, so it can be stopped when a user 
            // hovers the indication 
            timeout = window.setTimeout(function(){ 
                el.fadeOut(100); 
                currentId = undefined; 
            }, 500); 
        }, 

        // Set the element object when it's set. 
        // Typically this will only be called from the initial ajax-call made  
        // in init.js 
        setElement: function( newEl ) { 
            var self = this; 
             
            el = newEl; 
             
            el  .bind('mouseenter', function() { 
                    window.clearTimeout(timeout); 
                     
                    // Keep the Factlink highlighted 
                    $( '[data-factid=' + currentId + ']' ) 
                        .addClass('fl-active'); 
                }) 
                .bind('mouseleave', function() { 
                    self.hide(); 
                     
                    // Stop hightlighting the Faclink 
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
$.ajax({ 
  method: 'get', 
  dataType: 'jsonp', 
  crossDomain: true, 
  url: window.location.protocol + '//' + FactlinkConfig.api + '/factlink/indication.js', 
  success: function( data ) { 
    Factlink.Indicator.setElement( $( data ).attr('id','factlink-indicator').appendTo('body') ); 
  } 
});


var showIndicator = function(e,factId,orig_e) {
            Factlink.Indicator.showFor(factId, orig_e.pageX - 10, $(orig_e.target).offset().top + 10); 
};

var stopShowingIndicator = function(e,factId,orig_e) {
    Factlink.Indicator.hide();
};

$(window).bind("factlink:factHighlighted", showIndicator);
$(window).bind("factlink:factUnhighlighted",stopShowingIndicator);

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);