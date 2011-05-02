(function( Factlink ) {

Factlink.showInfo = function( el ) {
    if ( Factlink.modal.frame !== null ) {
        // @TODO: Check if we do want to remove the whole frame, maybe the user is changing stuff?
        Factlink.modal.frame.remove();
        Factlink.modal.frame = null;
    }
    
    Factlink.modal.frame = $('<iframe />');
    
	Factlink.modal.frame.attr('src', "http://development.factlink.com/factlink/show/" + $( el ).attr('data-factid') );
	Factlink.modal.frame.addClass("factlink-modal-frame");
	
	Factlink.overlay.show();
	
	Factlink.modal.frame.appendTo("body");
};

$( 'span.factlink' ).live('click', function() {
    Factlink.showInfo( this );
});

Factlink.modal = {
    frame: null,
};

})( window.Factlink );