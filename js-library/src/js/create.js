(function(Factlink) {
// Function which will return the Selection object
//@TODO: Add rangy support for IE

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

// Prepare a new Factlink
function prepareFact(rng, passage, top, left) {
    // Position the frame
    Factlink.remote.position(top, left);
    Factlink.modal.show.method();
}

// Bind the actual selecting
$('body').bind('mouseup', function(e) {
    // Retrieve all needed info of current selection
    var selectionInfo = Factlink.getSelectionInfo();
    // Retrieve the text from the selection
    var text          = selectionInfo.selection.getRangeAt(0).toString();

    // Check if the selected text is long enough to be added
    if (text !== undefined && text.length > 1) {
        if (FactlinkConfig.modus === "default") {
            Factlink.remote.prepareNewFactlink(text, selectionInfo.passage, window.location.href);
        } else if (FactlinkConfig.modus === "addToFact") {
            Factlink.remote.prepareNewFactAsEvidence(text, selectionInfo.passage, FactlinkConfig.url || window.location.href);
        }
        
        prepareFact(selectionInfo.selection.getRangeAt(0), selectionInfo.passage, e.clientY, e.clientX);
    }
});
})(window.Factlink);
