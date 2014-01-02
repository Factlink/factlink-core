# Adapted from https://github.com/okfn/annotator/blob/master/src/annotator.coffee
highlightNode = (node, id) ->
  # Ignore text nodes that contain only whitespace characters. This prevents
  # spans being injected between elements that can only contain a restricted
  # subset of nodes such as table rows and lists. This does mean that there
  # may be the odd abandoned whitespace node in a paragraph that is skipped
  # but better than breaking table layouts.
  return if /^\s*$/.test(node.nodeValue)

  # Don't re-wrap nodes that have been wrapped already
  $node = $(node)
  return if $node.parent().hasClass 'factlink'

  $highlight = $("<span class='factlink'></span>")
  $highlight.attr 'data-factid', id

  $node.wrapAll($highlight).parent().show()[0]

highlightRange = (normalizedRange, id) ->
  elements = []
  for node in normalizedRange.textNodes()
    element = highlightNode(node, id)
    elements.push element if element?
  elements

# Function to select the found ranges
FactlinkJailRoot.highlightFact = (text, id) ->
  ranges = FactlinkJailRoot.search text

  facts = []
  for range in ranges
    normalizedRange = new FactlinkJailRoot.Range.BrowserRange(range).normalize()
    elements = highlightRange(normalizedRange, id)
    facts.push new FactlinkJailRoot.Fact(id, elements)
  facts
