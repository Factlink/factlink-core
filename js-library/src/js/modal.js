(function( Factlink ) {
// The iFrame which holds the intermediate
var iFrame = $("<div />")
                .attr({
                    "id": "factlink-modal-frame"
                })
                .appendTo('body');

Factlink.showInfo = function( el ) {
    Factlink.remote.showFactlink( el.getAttribute("data-factid") );
    Factlink.modal.show.method();
};

// Handle a user click
$( 'span.factlink' ).live('click', function() {
    Factlink.showInfo( this );
});

// Object which holds the methods that can be called from the intermediate iframe
// These methods are also used by the internal scripts and can be called through
// Factlink.modal.FUNCTION.method() because easyXDM changes the object structure
Factlink.modal = {
    hide: function() {
        unbindClick();
        iFrame.hide();
    },
    show: function() {
        bindClick();
        iFrame.show();
    },
    highlightNewFactlink: function( fact, id ) {
        Factlink.selectRanges( Factlink.search(fact), id );
    }
};

var bindClick = function() {
        $( document ).bind('click', clickHandler);
    },
    unbindClick = function() {
        $( document ).unbind('click', clickHandler)
    },
    clickHandler = function() {
        Factlink.modal.hide.method();
    };

// INDICATOR

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
                x = mouseX + 10,
                y = mouseY - el.outerHeight(true) - 10;
            }

            window.clearTimeout( timeout );
            
            // Store the currentId;
            currentId = id;
            
            timeout = window.setTimeout(function(){
                if ( el === undefined )
                    return;
                
                el
                    .css({
                        top: y,
                        left: x
                    })
                    .show();
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
                    $( 'span.factlink[data-factid=' + currentId + ']').click();
                });
        },
        // Set the opinions
        setOpinions: function(believe, doubt, disbelieve) {
            el.find('li.fl-bar-proves').height( ( believe.percentage / 100 ) * 45);
            el.find('li.fl-bar-proves>div').width( believe.authority * 15);
            el.find('li.fl-bar-maybe').height( ( doubt.percentage / 100 ) * 45);
            el.find('li.fl-bar-maybe>div').width( doubt.authority * 15);
            el.find('li.fl-bar-denies').height( ( disbelieve.percentage / 100 ) * 45);
            el.find('li.fl-bar-denies>div').width( disbelieve.authority * 15);
        }
    };
})();

// Make sure the hover on an element works on all the paired span elements
$( 'span.factlink' ).live( 'mouseenter', function( e ) {
    var fctID = $( this ).attr( 'data-factid' );
    
    $( '[data-factid=' + fctID + ']' )
        .addClass('fl-active');
    
    // Show the Factlink indication
    Factlink.Indicator.setOpinions(
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
})
.live('mouseleave', function() {
    $( '[data-factid=' + $( this ).attr( 'data-factid' ) + ']' )
        .removeClass('fl-active');
    
    // Hide the indication element
    Factlink.Indicator.hide();
});
})( window.Factlink );