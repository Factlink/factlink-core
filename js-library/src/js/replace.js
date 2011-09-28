(function(Factlink) {
  // Function which walks the DOM in HTML source order
  // as long as func does not return false
  // Inspiration: Douglas Crockford, JavaScript: the good parts
  var walkTheDOM = function walk(node, func) {
        if (func(node) !== false) {
          node = node.firstChild;
          while (node) {
            if (walk(node, func) !== false) {
              node = node.nextSibling;
            } else {
              return false;
            }
          }
        } else {
          return false;
        }
      },
      // Regex for class find
      re = /(^|\s)factlink(\s|$)/,
      findRangesStartingInContainer = function(ranges, start, container) {
        var matches = [],
            j = start - 1;

        while (++j < ranges.length && ranges[j].startContainer === container) {
          // Push the match to the extraMatches helper
          matches.push(ranges[j]);
        }

        return matches;
      };

  // Function to select the found ranges
  Factlink.selectRanges = function(ranges, id, opinions) {
    // Loop through ranges (backwards)
    var matches = [];
    var results = [];
    
    for (var i = 0; i < ranges.length; i += matches.length) {
      // Check if the given factlink is not already selected 
      // (fixes multiple check marks when editing a factlink)
      if (re.test(ranges[i].startContainer.parentNode.className)) {
        matches.push({}); // Dirty hack: we should still skip one
        continue;
      }

      // Helper for posible extra matches within the current startNode
      matches = findRangesStartingInContainer(ranges, i, ranges[i].startContainer);

      //process all matches starting in ranges[i].startContainer
      for (var k = 0; k < matches.length; k++) {
        this.replaceFactNodes(matches[k], results);
      }
    }

    // This is where the actual parsing takes place
    // this.results holds all the textNodes containing the facts
    var len;
    
    for (var i = 0, len = results.length; i < len; i++) {
      var res = results[i];

      // Insert the fact-span
      insertFactSpan(
      res.startOffset, res.endOffset, res.node, id, opinions,
      // Only select the first range of every matched string
      // Needed for when one displayString is matched mutliple times on 
      // one page
      i % (results.length / ranges.length) === 0);
    }
  };

  // This is where the actual magic will take place
  // A Span will be inserted around the startOffset/endOffset 
  // in the startNode/endNode
  var insertFactSpan = function(startOffset, endOffset, node, id, opinions, isFirst) {
        // Value of the startNode, represented in an array
        var startNodeValue = node.nodeValue.split(''),
        
        
            // The selected text
            selTextStart = startNodeValue.splice(startOffset, startNodeValue.length);

        if (endOffset < node.nodeValue.length && endOffset !== 0) {
          var after = selTextStart.splice(endOffset - startOffset, selTextStart.length).join('');

          // Slice the array by changing it's length
          selTextStart.length = endOffset - startOffset;

          // Insert the textnode with the remaining text after the 
          // current textNode
          node.parentNode.insertBefore(document.createTextNode(after), node.nextSibling);
        }
        // Create a reference to the actual "fact"-span
        var span = createFactSpan(selTextStart.join(''), id, opinions);

        // Remove the last part of the nodeValue
        node.nodeValue = startNodeValue.join('');

        // Insert the span right after the startNode 
        // (there is no insertAfter available)
        node.parentNode.insertBefore(span, node.nextSibling);

        // If this span is the first in a range of fact-spans
        if (isFirst) {
          var first = createFactSpan("", id, opinions, true);
          first.innerHTML = "&#10003;";

          node.parentNode.insertBefore(first, span);
        }
      },
      // Create a "fact"-span with the right attributes
      createFactSpan = function(text, id, opinions, first) {
        var span = document.createElement('span');

        // Set the span attributes
        span.className = "factlink";
        span.setAttribute('data-factid',id); 
		    span.setAttribute('data-fact-disbelieve-percentage',opinions['disbelieve']['percentage']); 
		    span.setAttribute('data-fact-doubt-percentage',opinions['doubt']['percentage']); 
		    span.setAttribute('data-fact-believe-percentage',opinions['believe']['percentage']); 
		    span.setAttribute('data-fact-authority',opinions['authority']); 

        if (first === true) {
          span.className += " fl-first";
        }

        span.setAttribute('data-factid', id);

        // IE Doesn't support the standard (textContent) and Firefox doesn't 
        // support innerText
        if (document.getElementsByTagName("body")[0].innerText === undefined) {
          span.textContent = text;
        } else {
          span.innerText = text;
        }

        return span;
      };

  // Function that tracks the DOM for nodes containing the fact
  Factlink.replaceFactNodes = function(range, results) {
    // Only parse the nodes if the startNode is already found, 
    // this boolean is used for tracking
    var foundStart = false;

    // Walk the DOM in the right order and call the function for every 
    // node it passes
    walkTheDOM(range.commonAncestorContainer, function(node) {
      // We're only interested in textNodes
      if (node !== undefined && node.nodeType === 3) { //3 == text (so therefore leaf)
        var rStartOffset = 0;
        if (node === range.startContainer) {
          foundStart = true;
          rStartOffset = range.startOffset;
        }

        if (foundStart) {
          var rEndOffset = node.nodeValue.length;
          if (node === range.endContainer) {
            rEndOffset = range.endOffset;
          }

          // Push the right info to the results array, the info 
          // is being parsed later (selectRanges -end)
          results.push({
            startOffset: rStartOffset,
            endOffset: rEndOffset,
            node: node
          });
        }

        if (foundStart && node === range.endContainer) {
          // If we encountered the last node we don't 
          // need to walk the DOM anymore
          return false;
        }
      }
    });
  };
})(window.Factlink);
