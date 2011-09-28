
(function(Factlink) {
    
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
        showFor: function( id, mouseX, mouseY ) { 
            // Get the Factlink-object 
            var fl = $( 'span.factlink[data-factid=' + id + ']'); 
             
            if ( id !== currentId ) { 
                x = mouseX + 10;
                y = mouseY - el.outerHeight(true) - 10; 
            } 
 
            window.clearTimeout( timeout ); 
             
            // Store the currentId; 
            currentId = id; 
             
            timeout = window.setTimeout(function(){ 
                if ( el === undefined ) {
                    return; 
                } else {
                  el.css({ 
                        top: y, 
                        left: x 
                        }) 
                    .show(); 
               }
            }, 10); 
        }, 
        // Makes the indicator hide itself 
        hide: function() { 
            // Make sure there isn't an timeout running 
            window.clearTimeout( timeout ); 
             
            // Put the hiding in a timeout, so it can be stopped when a user 
            // hovers the indication 
            timeout = window.setTimeout(function(){ 
                // Simple hiding 
                el.hide(); 
                 
                // Reset currentId 
                currentId = undefined; 
            }, 500); 
        }, 
        // Stop the timeout, used to stop hiding the indication 
        stop: function() { 
            window.clearTimeout(timeout); 
        }, 
        // Set the element object when it's set. 
        // Typically this will only be called from the initial ajax-call made  
        // in init.js 
        setElement: function( newEl ) { 
            var self = this; 
             
            el = newEl; 
             
            el  .bind('mouseenter', function() { 
                    self.stop(); 
                     
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
                    $( 'span.factlink[data-factid=' + currentId + ']:first').click(); 
                    return false; 
                }); 
        }, 
        // Set the opinions 
        setOpinions: function(believe, doubt, disbelieve) { 
            console.log([believe, doubt, disbelieve]);
            el.find('div').hide()
            el.find('div.believe').show()
        } 
    }; 
})();
console.info($);
$.ajax({ 
  method: 'get', 
  dataType: 'jsonp', 
  crossDomain: true, 
  url: window.location.protocol + '//' + FactlinkConfig.api + '/factlink/indication.js', 
  success: function( data ) { 
    console.info('hoi');
    Factlink.Indicator.setElement( $( data ).attr('id','factlink-indicator').appendTo('body') ); 
  } 
});


})(window.Factlink);
