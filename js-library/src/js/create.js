(function( Factlink ) {
// Make the user able to add a Factlink
Factlink.submitFact = function(){
    var selection = window.getSelection();
    
    if ( window.rangy !== undefined ) {
        selection = window.rangy.getSelection();
    }
    
    try {
        // Get the selected text
        var range = selection.getRangeAt(0);
    } catch(e) {
        alert("bam");
        // Possibly the user didn't select anything
        return false;
    }
    
    if (range.toString().length < 1) {
        //@TODO: Fix the loader
        // Tell the loader we're done
        // FL.Loader.finish();
        
        // Return to make the function stop
        return false;
    }
    
    $.ajax({
        url: 'http://tom:1337/factlink/new',
        dataType: 'jsonp',
        crossDomain: true,
        jsonp: "callback",
        type: 'post',
        data: {
            url: window.location.href,
            fact: range.toString()
        }
    }).success(function(data) {
        if (data.status === true) {
            // Select the selected text
            Factlink.selectRanges([range]);
            
            //@TODO: Fix the loader
            // The loader can hide itself
            // FL.Loader.finish();
        } else {
            window.console.info( data );
            alert("Something went wrong");
            
            //@TODO: Fix the loader
            // The Loader can hide itself
            // FL.Loader.finish();
        }
    }).error(function(data) {
        //@TODO: Fix the loader
        //TODO: Better errorhandling
        // FL.Loader.finish();
    });
};

$( 'body' ).bind('mouseup', function(e) {
    var rng = window.getSelection().getRangeAt(0);
    
    if ( rng.toString().length > 0 ) {
        Factlink.timout = setTimeout(function() {
            Factlink.startSubmitting(rng, e.pageY, e.pageX);
        }, 500);
    }
});

Factlink.startSubmitting = function(rng, top, left) {
    var offset = {
            top: top,
            left: left
        };
    
    if (Factlink.iframe) {
        Factlink.iframe.remove();
    }
    
    Factlink.iframe = $( '<iframe class="factlink-modal-frame-test" src="http://factlink:8000/examples/basic/menu.html?' + rng.toString() + '///' + window.location.href + '" />').appendTo('body');
    
    Factlink.iframe.css({
        position: "absolute",
        top: offset.top,
        left: offset.left
    });
    
    Factlink.iframe.fadeIn();
};
})( window.Factlink );