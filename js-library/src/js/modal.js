(function( Factlink ) {

Factlink.showInfo = function( el ) {
    Factlink.remote.showFactlink( el.getAttribute("data-factid") );
    
    // Position the frame
    Factlink.modal.showFrame.method();
    Factlink.modal.showOverlay.method();
};

$( 'span.factlink' ).live('click', function() {
    Factlink.showInfo( this );
});

Factlink.modal = {
    positionFrame: function( top, left ) {
        Factlink.$frame.css({
            top: top,
            left: left
        });
    },
    resetStyle: function() {
        Factlink.$frame.attr('style','');
    },
    setFrameBounds: function( width, height ) {
        var $frame = Factlink.$frame;
        
        $frame.css({
            height: height,
            width: width
        });
        
        if ( $frame.hasClass("show") ) {
            $frame.css({
                margin: "-" + height / 2 + "px 0 0 -" + width / 2 + "px"
            });
        }
    },
    hideFrame: function() {
        unbindClick();
        Factlink.$frame.hide();
    },
    showFrame: function() {
        bindClick();
        Factlink.$frame.show();
    },
    setFrameType: function( type ) {
        Factlink.$frame
            .attr('class', type)
            .show();
    },
    showOverlay: function() {
        Factlink.overlay.show();
    },
    hideOverlay: function() {
        Factlink.overlay.hide();
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
        Factlink.modal.hideOverlay.method();
        Factlink.modal.hideFrame.method();
    };
})( window.Factlink );