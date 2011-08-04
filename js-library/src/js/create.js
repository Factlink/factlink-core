(function(Factlink) {
    // Timeout will hold the timeout id of the current timeout
    var timeout = null;

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
    function prepare(rng, passage, top, left) {
        // Position the frame
        Factlink.remote.position(top, left);
        Factlink.modal.show.method();
    }

    // Bind the actual selecting
    $('body').bind('mouseup', function(e) {
        // If there is an active timeout
        if (timeout) {
            // Clear it!
            window.clearTimeout(timeout);
        }

        // Retrieve all needed info of current selection
        var selectionInfo = Factlink.getSelectionInfo();
        // Get the selection object
        var selection     = selectionInfo.selection;
        // Retrieve the text from the selection
        var text          = selection.getRangeAt(0).toString();

        // Check if the selected text is long enough to be added
        if (text !== undefined && text.length > 1) {
            // We can already start loading the prepare page in the background, this 
            // way the script looks smoother
            // TODO: This whole script is due for some big refactors, I don't like the way things are done right now, it doesn't seem consistent and I think it's to hard to understand for other people then the one who wrote it.
            if (FactlinkConfig.modus === "default") {
                Factlink.remote.prepareNewFactlink(text, selectionInfo.passage, window.location.href);
            } else if (FactlinkConfig.modus === "addToFact") {
                Factlink.remote.prepareNewEvidence(text, selectionInfo.passage, window.location.href);
            }

            // Store the time out
            timeout = setTimeout(function() {
                // Retrieve all needed info of current selection
                var selectionInfo = Factlink.getSelectionInfo();
                // Make sure the text is still selected
                var selection     = selectionInfo.selection;

                if (selection.rangeCount > 0) {
                    prepare(selection.getRangeAt(0), selectionInfo.passage, e.clientY, e.clientX);
                }
            },
            500);
        }
    });
})(window.Factlink);
