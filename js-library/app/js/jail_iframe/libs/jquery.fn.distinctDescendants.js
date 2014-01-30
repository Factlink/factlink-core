// Adapted from http://stackoverflow.com/a/10152739
jQuery.fn.distinctDescendants = function() {
    var nodes = [];
    var parents = [];

    // First, copy over all matched elements to nodes.
    jQuery(this).each(function(index, Element) {
        nodes.push(Element);
    });

    // Then, for each of these nodes, check if it is parent to some element.
    for (var i=0; i<nodes.length; i++) {
        var node_to_check = nodes[i];
        jQuery(this).each(function(index, Element) {

            // Skip self comparisons.
            if (Element == node_to_check) {
                return;
            }

            // Use .tagName to allow .find() to work properly.
            if((jQuery(node_to_check).find(Element.tagName).length > 0)) {
                if (parents.indexOf(node_to_check) < 0) {
                    parents.push(node_to_check);
                }
            }
        });
    }

    // Finally, construct the result.
    var result = [];
    for (var i=0; i<nodes.length; i++) {
        var node_to_check = nodes[i];
        if (parents.indexOf(node_to_check) < 0) {
            result.push(node_to_check);
        }
    }

    return jQuery(result);
};
