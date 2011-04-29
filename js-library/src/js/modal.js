(function( Factlink ) {
Factlink.showInfo = function( el ) {
    Factlink.iframe = $('<iframe style="border: none;" />');
    
    // iframe.attr('src', "http://factlink:8000/examples/basic/menu.html?2");
	Factlink.iframe.attr('src', "http://tom:1337/factlink/show/" + $( el ).attr('data-factid') );
	Factlink.iframe.addClass("factlink-modal-frame");
	
	Factlink.overlay.show();
	
	Factlink.iframe.appendTo("body");
};

$( 'span.factlink' ).live('click', function() {
    Factlink.showInfo( this );
});

var section = $( 'body' );

// The ul-storage container
var cont = $('<div class="factlink-ul-storage" />').appendTo(section);

$('li', section).live('click',
    function(){
        var el = $(this),
            offset = el.offset(),

            // Find and clone the containing ul
            ul = el.data('ul');

        if (ul !== undefined) {
            ul.css({
                position: 'absolute',
                display: 'block',
                top: offset.top - 1,
                left: offset.left + el.outerWidth()
            }).show();
        }

        // Make the current LI active
        el.addClass('active');

        // Hide all the other open subs
        var subs = el.siblings();

        if ( ul !== undefined ) {
            subs = subs.add( ul.children('li') );
        } else { // There is no following sub
            // alignItems( $('ul.factlink-choices', section).offset().top );
			
        }

        subs.each(function(i, val) {
            var ul = $( this ).data('ul');

            // Remove the active class, just to be sure
            $( this ).removeClass('active');

            // Check if there is a sub
            if ( ul !== undefined ) {
                // Hide the sub
                ul.hide();

                // To the same on the subs of the sub (recursive)
                ul.children( 'li' ).each(arguments.callee);
            }
        });
    });

})( window.Factlink );