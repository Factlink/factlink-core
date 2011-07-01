(function(window){
// Check if all Factlinks are loaded
window.isFullyLoaded = false;

var // Integer value holding current page number
    page = 1,
    // Location string used for sort direction/name parsing
    loc = location.pathname.split("/"),
    // Sorting variables
    sort_direction = "",
    sort_column = "",
    // Is there a search going on?
    search_string = /\?s=([a-zA-Z0-9]*)/.exec(window.location.search),
    // Are we currently loading?
    isLoading = false,
    // Loading helpers
    start_loading = function() {
        if ( window.isFullyLoaded )
            return;
        
        // Change boolean
        isLoading = true;
        
        $( '#load_more' ).hide();
        $( '#loading' ).show();
    },
    stop_loading = function() {
        if ( window.isFullyLoaded )
            return;
        
        // Change boolean
        isLoading = false;
        
        $( '#loading' ).hide();
        $( '#load_more' ).show();
    },
    // Function that will check if there is a need for content
    check_scroll = function() {
        if ( $( document ).height() - ( $( window ).scrollTop() + $( window ).height() ) < 700 ) {
            // Start loading
            start_loading();
            
            load_more();
        }
    },
    // Function that will load more items
    load_more = function() {
        $.ajax({
            url: '/search/page/' + ++page + (sort_direction.length > 0 && sort_column.length > 0 ? '/' + sort_column + '/' + sort_direction : "" ) + '.js' + ( search_string && search_string.length === 2 ? "?s=" + search_string[1] : "" ) ,
            dataType: 'script',
            success: function() {
                // Done loading!
                stop_loading();
            }
        });
    };

// Check if the user is currently sorting    
if ( loc[loc.length - 1] === "asc" || loc[loc.length - 1] === "desc" ) {
    sort_direction = loc[loc.length - 1];
    sort_column = loc[loc.length - 2];
}

$( window ).scroll(function() {
    if ( !isLoading && !window.isFullyLoaded ) {        
        // Check the scroll
        check_scroll();
    }
});

$( '#load_more a' ).bind('click', function(e) {    
    load_more();
    
    e.preventDefault();
    return false;
})

})(window);