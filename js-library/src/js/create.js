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
        url: 'http://development.factlink.com/factlink/new',
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
            //@TODO: Better errorhandling
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

// Track user selection change
var sel = null,
    sel_text = null,
    min_len = 10,
    getText = function(){
        if (window.getSelection) {
            var d = window.getSelection()
        } else {
            if (document.getSelection) {
                var d = document.getSelection()
            } else {
                if (document.selection) {
                    var d = document.selection.createRange().text
                } else {
                    return '';
                }
            }
        }
        return d;
    };

$( 'body' ).bind('mouseup', function(e) {
    sel = getText();
    sel_text = sel.toString();
    
    if ( sel_text !== null && sel_text.length > min_len ) {
        Factlink.timeout = setTimeout(function() {
            Factlink.startSubmitting(sel.getRangeAt(0), e.pageY, e.pageX);
        }, 500);
    }
});

Factlink.startSubmitting = function(rng, top, left) {
    var offset = {
            top: top,
            left: left
        };
    
    if ( Factlink.modal.frame !== null ) {
        // @TODO: Check if we do want to remove the whole frame, maybe the user is changing stuff?
        Factlink.modal.frame.remove();
        Factlink.modal.frame = null;
    }
    
    Factlink.modal.frame = $( '<iframe />').appendTo('body');
    Factlink.modal.frame.addClass( "factlink-modal-frame-test" );
    Factlink.modal.frame.attr('src', 'http://chrome-extension.factlink.com/examples/basic/menu.html?' + rng.toString() + '///' + window.location.href);
    Factlink.modal.frame.css({
        position: "absolute",
        top: offset.top,
        left: offset.left
    });
    
    Factlink.modal.frame.fadeIn();
    
    // Hide the menu when there is a click outside of it
    $( "body" ).one( 'click', function() {
        Factlink.modal.frame.remove();
        Factlink.modal.frame = null;
    });
    
    //@TODO: This is a hard one, how are we going to check if the Factlink is actually submitted, so we can know if we need to highlight it.
    this.selectRanges( [rng] );
};
})( window.Factlink );