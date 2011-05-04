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
        url: Factlink.conf.api.loc + '/factlink/new',
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
    // Function which will return the Selection object
    //@TODO: Add rangy support for IE
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

// Bind the actual selecting
$( 'body' ).bind('mouseup', function(e) {
    // Get the selection object
    sel = getText();
    // Retrieve the text from the selection
    sel_text = sel.toString();
    
    // Hide all the (possible) open Factlink windows
    try {
        Factlink.modal.frame.remove();
        Factlink.modal.frame = null;
        Factlink.overlay.hide();
    } catch (e) {}
    
    // Check if the selected text is long enough to be added
    if ( sel_text !== null && sel_text.length > min_len && sel_text.rangeCount > 0 ) {
        // Store the time out
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
    
    // Create the frame that will hold the menu/edit box
    Factlink.modal.frame = $( '<iframe />')
        .attr({
            "class": "factlink-modal-frame-submit",
            "name": "myiframe",
            "src": "http://www.google.nl"
        })
        .css({
            top: offset.top,
            left: offset.left
        })
        .appendTo('body');
    
    // Make a POST call to the iframe with the data
    postToIframe(
            Factlink.conf.api.loc + '/factlink/prepare', 
            {
                url: window.location.href,
                fact: rng.toString()
            },
            Factlink.modal.frame.attr('name'));
    
    // Fade the modal window in
    Factlink.modal.frame.fadeIn();
    
    // @TODO: How are we going to check if the Factlink is actually submitted, so we can know if we need to highlight it.
    //this.selectRanges( [rng] );
};

var postToIframe = function(url, obj, iframe) {
        // Create an empty form
        // @TODO: Check if this form doesn't have to be appended to the body of a document before it can be submitted
    var form = $( '<form />' ),
        // Check if the iframe variable is a string or an element
        target = ( typeof iframe === "string" ? iframe : iframe.attr('name') );
    
    // Iframe has no name, create one
    if ( target === undefined ) {
        // Create a name for the iframe, try to make it as unique as possible
        var tmp = 'factlink-iframe-' + ( new Date() ).getTime();
        
        iframe.attr('name', tmp);
        target = tmp;
    }
    
    // Set the attributes
    form.attr({
        action: url, 
        method: "get",
        target: target
    });
    
    // Loop through the values that have to be sent
    for ( var i in obj ) {
        if ( obj.hasOwnProperty(i) ) {
            // Create a new input field
            $( '<input />' )
                .attr({
                    type: "text",
                    value: obj[i],
                    name: i
                })
                // And append it to the form
                .appendTo(form);
        }
    }
    
    // Submit the form
    form.submit();
};
})( window.Factlink );