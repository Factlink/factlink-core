(function(Factlink, $, _, easyXDM, window, undefined) {
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
    var i;

    for (i = 0; i < ranges.length; i += matches.length) {
      // Check if the given factlink is not already selected
      // (fixes multiple check marks when editing a factlink)
      if (re.test(ranges[i].startContainer.parentNode.className)) {
        matches.push({}); // Dirty hack: we should still skip one
        continue;
      }

      // Helper for posible extra matches within the current startNode
      matches = findRangesStartingInContainer(ranges, i, ranges[i].startContainer);

      //process all matches starting in ranges[i].startContainer
      // Walk backwards over the matches to make sure the node references will stay intact
      for (var k = matches.length - 1; k >= 0; k--) {
        this.parseFactNodes(matches[k], results, k);
      }
    }
    // This is where the actual parsing takes place
    // this.results holds all the textNodes containing the facts
    var len,
        elements = [],
        ret = [];

    for (i = 0, len = results.length; i < len; i++) {
      var res = results[i];

      elements[res.matchId] = elements[res.matchId] || [];

      // Insert the fact-span
      elements[res.matchId] = elements[res.matchId].concat(insertFactSpan(
        res.startOffset,
        res.endOffset,
        res.node,
        id,
        // Only select the first range of every matched string
        // Needed for when one displayString is matched mutliple times on
        // one page
        res.first));
    }

    for ( var el in elements ) {
      if ( elements.hasOwnProperty(el) ) {
        ret.push( new Factlink.Fact(id, elements[el], opinions) );
      }
    }

    return ret;
  };

  // This is where the actual magic will take place
  // A Span will be inserted around the startOffset/endOffset
  // in the startNode/endNode
  var insertFactSpan = function(startOffset, endOffset, node, id, isFirst) {
        // Value of the startNode, represented in an array
        var startNodeValue = node.nodeValue.split(''),
            // The selected text
            selTextStart = startNodeValue.splice(startOffset, startNodeValue.length),
            spans = [];

        if (endOffset < node.nodeValue.length && endOffset !== 0) {
          var after = selTextStart.splice(endOffset - startOffset, selTextStart.length).join('');

          // Slice the array by changing it's length
          selTextStart.length = endOffset - startOffset;

          // Insert the textnode with the remaining text after the
          // current textNode
          node.parentNode.insertBefore(document.createTextNode(after), node.nextSibling);
        }
        // Create a reference to the actual "fact"-span
        var span = createFactSpan(selTextStart.join(''), id, isFirst);

        // Remove the last part of the nodeValue
        node.nodeValue = startNodeValue.join('');

        // Insert the span right after the startNode
        // (there is no insertAfter available)
        node.parentNode.insertBefore(span, node.nextSibling);

        // Add span to stash
        spans.push(span);

        return spans;
      },
      // Create a "fact"-span with the right attributes
      createFactSpan = function(text, id, first) {
        var span = $(document.createElement('span'))
          .addClass('factlink')
          .attr('data-factid', id);

        if (first === true) {
          span.addClass("fl-first");
        }

        span.html(text);

        return span[0];
      };

  // Function that tracks the DOM for nodes containing the fact
  Factlink.parseFactNodes = function(range, results, matchId) {
    // Only parse the nodes if the startNode is already found,
    // this boolean is used for tracking
    var foundStart = false;
    var first = true;

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
            node: node,
            matchId: matchId,
            first: first
          });

          first = false;
        }

        if (foundStart && node === range.endContainer) {
          // If we encountered the last node we don't
          // need to walk the DOM anymore
          return false;
        }
      }
    });
  };
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
