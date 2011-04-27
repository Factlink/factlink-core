(function( Factlink ) {
    
Factlink.buildMenu = function() {
        // List of the available choices, used to build dynamicly
    var choices = {
            'I know': {
                'something that': {
                    'supports this' : false,
                    'weakens this': false,
                    'proves this': false,
                    'refutes this': false
                },
                'topics': false,
                'someone who': {
                    'should participate': false
                }
            },
            'I want': {
                'to know about': false,
                'to ask/tell someone about': false
            }
        },
        // The ul which will contain the menu
        ul = document.createElement('ul');
        // Method to build the menu (recursive action baby)
        function build_els(parent, root) {
            var obj, el, ul;
            
            // If the parent is not a UL, create one
            if ( parent.tagName !== "UL" ) {
                ul = document.createElement("ul");
                
                parent.appendChild(ul);
                
                parent = ul;
            }
            
            // Loop through the choices
            for ( var i in root ) {
                // The array of sub-menu's
                obj = root[i];
                
                // for-in fix for JavaScript
                if ( root.hasOwnProperty(i) ) {
                    // Create the element
                    el = document.createElement("li");
                    el.textContent = i;
                    
                    // Append the LI to the parent
                    parent.appendChild(el);
                    
                    // If there are sub-menu's
                    if ( obj !== false ) {
                        // Recursivly build them
                        build_els(el, obj);
                    }
                }
            }
        };
    
    if ( this.built !== undefined ) {
        // Menu already built
        return this.built;
    }
    
    ul.className = "factlink-choices";
    
    build_els( ul, choices );
    
    this.built = ul;
    
    return ul;
}
    
Factlink.showInfo = function( id ) {
    // Build the choices menu
    var $ul = $( this.buildMenu() );
    
    $ul.appendTo('body');
};

$( 'span.factlink' ).live('click', function() {
    var offset = $( this ).offset(),
        pos = {
            top: offset.top,
            left: offset.left
        };
        
    Factlink.showInfo( $( this ).attr('id') );
});

})( window.Factlink );