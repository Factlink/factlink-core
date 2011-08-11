(function(Factlink) {
// Function which will return the Selection object
//@TODO: Add rangy support for IE

// Load the needed prepare menu & put it in a container
var urlToLoad,
    $prepare = $('<div />')
                    .attr('id', 'fl-prepare')
                    .appendTo("body");

if (FactlinkConfig.modus === "default") {
    urlToLoad = '//' + FactlinkConfig.api + 'factlink/prepare/new';
} else if (FactlinkConfig.modus === "addToFact") {
    urlToLoad = '//' + FactlinkConfig.api + 'factlink/prepare/evidence';
}

$.ajax({
    url: urlToLoad,
    dataType: "jsonp",
    crossDomain: true,
    cache: false,
    success: function(data) {
        $prepare.html( data );
    }
});

function getTextRange() {
    var d = '';
    if (window.getSelection) {
        d = window.getSelection();
    } else {
        if (document.getSelection) {
            d = document.getSelection();
        } else if (document.selection) {
            d = document.selection.createRange().text;
        }
    }
    return d;
}

function positionFrameToCoord($frame, x, y) {
    $frame.css({
        position: 'absolute',
        top: y + 'px',
        left: x + 'px'
    });
}

// We make this a global function so it can be used for direct adding of facts
// (Right click with chrome-extension)
Factlink.getSelectionInfo = function() {
    // Get the selection object
    var selection = getTextRange();

    //TODO: Add passage detection here
    return {
        selection: selection,
        passage: ""
    };
};

// Bind the actual selecting
$('body').bind( 'mouseup', function( e ) {
    // Retrieve all needed info of current selection
    var selectionInfo = Factlink.getSelectionInfo();
    // Retrieve the text from the selection
    var text          = selectionInfo.selection.getRangeAt(0).toString();

    // Check if the selected text is long enough to be added
    if (text !== undefined && text.length > 1) {
        if (FactlinkConfig.modus === "default") {
            
        } else if (FactlinkConfig.modus === "addToFact") {
            
        }
        
        positionFrameToCoord($prepare, e.clientX, e.clientY);
        
    }
});
})(window.Factlink);