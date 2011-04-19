(function( Factlink ) {
// Make the user able to add a Factlink
Factlink.prototype.submitFact = function(){
    var that = this;
    
    if ( window.rangy === undefined ) {
        var selection = window.getSelection();
    } else { // IE
        var selection = window.rangy.getSelection();
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
        // Tell the loader we're done
        FL.Loader.finish();
        
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
            url: location.href,
            fact: range.toString()
        }
    }).success(function(data) {
        if (data.status == true) {
            // Select the selected text
            that.selectRanges([range]);
            
            // The loader can hide itself
            FL.Loader.finish();
        } else {
            console.info( data );
            alert("Something went wrong");
            
            // The Loader can hide itself
            FL.Loader.finish();
        }
    }).error(function(data) {
        //TODO: Better errorhandling
        FL.Loader.finish();
    });
};
})( Factlink );