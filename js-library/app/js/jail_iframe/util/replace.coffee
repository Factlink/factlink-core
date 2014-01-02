# Function which walks the DOM in HTML source order
# as long as func does not return false
# Inspiration: Douglas Crockford, JavaScript: the good parts
walkTheDOM = (node, func) ->
  if func(node) != false
    node = node.firstChild
    while node
      if walkTheDOM(node, func) != false
        node = node.nextSibling
      else
        return false
  else
    false

findRangesStartingInContainer = (ranges, start, container) ->
  matches = []
  j = start - 1

  # Push the match to the extraMatches helper
  while ++j < ranges.length && ranges[j].startContainer == container
    matches.push ranges[j]
  matches

# Create a "fact"-span with the right attributes
createFactSpan = (text, id) ->
  span = $(document.createElement('span'))
  span.addClass 'factlink'
  span.attr 'data-factid', id
  span.html text
  span[0]

# This is where the actual magic will take place
# A Span will be inserted around the startOffset/endOffset
# in the startNode/endNode
insertFactSpan = (startOffset, endOffset, node, id) ->
  # Value of the startNode, represented in an array
  startNodeValue = node.nodeValue.split('')

  # The selected text
  selTextStart = startNodeValue.splice(startOffset, startNodeValue.length)

  spans = []

  if endOffset < node.nodeValue.length && endOffset != 0
    after = selTextStart.splice(endOffset - startOffset, selTextStart.length).join('')

    # Slice the array by changing it's length
    selTextStart.length = endOffset - startOffset

    # Insert the textnode with the remaining text after the
    # current textNode
    node.parentNode.insertBefore document.createTextNode(after), node.nextSibling

  # Create a reference to the actual "fact"-span
  span = createFactSpan(selTextStart.join(''), id)

  # Remove the last part of the nodeValue
  node.nodeValue = startNodeValue.join('')

  # Insert the span right after the startNode
  # (there is no insertAfter available)
  node.parentNode.insertBefore span, node.nextSibling

  # Add span to stash
  spans.push span

  spans


# Function that tracks the DOM for nodes containing the fact
parseFactNodes = (range, results, matchId) ->
  # Only parse the nodes if the startNode is already found,
  # this boolean is used for tracking
  foundStart = false

  # Walk the DOM in the right order and call the function for every
  # node it passes
  walkTheDOM range.commonAncestorContainer, (node) ->

    # We're only interested in textNodes
    if node?.nodeType == 3 #3 == text (so therefore leaf)
      rStartOffset = 0
      if node == range.startContainer
        foundStart = true
        rStartOffset = range.startOffset
      if foundStart
        rEndOffset = node.nodeValue.length
        if node == range.endContainer
          rEndOffset = range.endOffset

        # Push the right info to the results array, the info
        # is being parsed later (selectRanges -end)
        results.push
          startOffset: rStartOffset
          endOffset: rEndOffset
          node: node
          matchId: matchId

      # If we encountered the last node we don't
      # need to walk the DOM anymore
      if foundStart && node == range.endContainer
        return false


# Function to select the found ranges
FactlinkJailRoot.selectRanges = (ranges, id) ->
  # Loop through ranges (backwards)
  matches = []
  results = []
  uniqueMatchId = 0

  i = 0
  while i < ranges.length
    # Check if the given factlink is not already selected
    # (fixes multiple check marks when editing a factlink)
    re = /(^|\s)factlink(\s|$)/
    if re.test(ranges[i].startContainer.parentNode.className)
      matches.push {} # Dirty hack: we should still skip one
      continue

    # Helper for posible extra matches within the current startNode
    matches = findRangesStartingInContainer(ranges, i, ranges[i].startContainer)

    #process all matches starting in ranges[i].startContainer
    # Walk backwards over the matches to make sure the node references will stay intact
    k = matches.length - 1

    while k >= 0
      parseFactNodes matches[k], results, uniqueMatchId++
      k--

    i += matches.length

  # This is where the actual parsing takes place
  # this.results holds all the textNodes containing the facts
  elements = {}
  ret = []
  i = 0
  len = results.length

  while i < len
    res = results[i]
    elements[res.matchId] = elements[res.matchId] or []

    # Insert the fact-span
    elements[res.matchId] = elements[res.matchId].concat(insertFactSpan(res.startOffset, res.endOffset, res.node, id))
    i++

  for matchId of elements when elements.hasOwnProperty(matchId)
    ret.push new FactlinkJailRoot.Fact(id, elements[matchId])

  ret
