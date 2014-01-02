# Copied from https://github.com/okfn/annotator/blob/master/src/range.coffee
# and https://github.com/okfn/annotator/blob/master/src/util.coffee

Util = {}
# Public: determine the first text node in or after the given jQuery node.
Util.getFirstTextNodeNotBefore = (n) ->
  switch n.nodeType
    when Node.TEXT_NODE
      return n # We have found our text node.
    when Node.ELEMENT_NODE
      # This is an element, we need to dig in
      if n.firstChild? # Does it have children at all?
        result = Util.getFirstTextNodeNotBefore n.firstChild
        if result? then return result
    else
      # Not a text or an element node.
  # Could not find a text node in current node, go forward
  n = n.nextSibling
  if n?
    Util.getFirstTextNodeNotBefore n
  else
    null

Util.flatten = (array) ->
  flatten = (ary) ->
    flat = []

    for el in ary
      flat = flat.concat(if el and $.isArray(el) then flatten(el) else el)

    return flat

  flatten(array)

# Public: Finds all text nodes within the elements in the current collection.
#
# Returns a new jQuery collection of text nodes.
Util.getTextNodes = (jq) ->
  getTextNodes = (node) ->
    if node and node.nodeType != Node.TEXT_NODE
      nodes = []

      # If not a comment then traverse children collecting text nodes.
      # We traverse the child nodes manually rather than using the .childNodes
      # property because IE9 does not update the .childNodes property after
      # .splitText() is called on a child text node.
      if node.nodeType != Node.COMMENT_NODE
        # Start at the last child and walk backwards through siblings.
        node = node.lastChild
        while node
          nodes.push getTextNodes(node)
          node = node.previousSibling

      # Finally reverse the array so that nodes are in the correct order.
      return nodes.reverse()
    else
      return node

  jq.map -> Util.flatten(getTextNodes(this))

Range = {}
FactlinkJailRoot.Range = Range

class Range.RangeError extends Error
  constructor: (@type, @message, @parent=null) ->
    super(@message)

# Public: Creates a wrapper around a range object obtained from a DOMSelection.
class Range.BrowserRange

  # Public: Creates an instance of BrowserRange.
  #
  # object - A range object obtained via DOMSelection#getRangeAt().
  #
  # Examples
  #
  #   selection = window.getSelection()
  #   range = new Range.BrowserRange(selection.getRangeAt(0))
  #
  # Returns an instance of BrowserRange.
  constructor: (obj) ->
    @commonAncestorContainer = obj.commonAncestorContainer
    @startContainer          = obj.startContainer
    @startOffset             = obj.startOffset
    @endContainer            = obj.endContainer
    @endOffset               = obj.endOffset

  # Public: normalize works around the fact that browsers don't generate
  # ranges/selections in a consistent manner. Some (Safari) will create
  # ranges that have (say) a textNode startContainer and elementNode
  # endContainer. Others (Firefox) seem to only ever generate
  # textNode/textNode or elementNode/elementNode pairs.
  #
  # Returns an instance of Range.NormalizedRange
  normalize: (root) ->
    if @tainted
      console.error(_t("You may only call normalize() once on a BrowserRange!"))
      return false
    else
      @tainted = true

    r = {}

    # Look at the start
    if @startContainer.nodeType is Node.ELEMENT_NODE
      # We are dealing with element nodes
      r.start = Util.getFirstTextNodeNotBefore @startContainer.childNodes[@startOffset]
      r.startOffset = 0
    else
      # We are dealing with simple text nodes
      r.start = @startContainer
      r.startOffset = @startOffset

    # Look at the end
    if @endContainer.nodeType is Node.ELEMENT_NODE
      # Get specified node.
      node = @endContainer.childNodes[@endOffset]

      if node? # Does that node exist?
        # Look for a text node either at the immediate beginning of node
        n = node
        while n? and (n.nodeType isnt Node.TEXT_NODE)
          n = n.firstChild
        if n? # Did we find a text node at the start of this element?
          r.end = n
          r.endOffset = 0

      unless r.end?
        # We need to find a text node in the previous node.
        node = @endContainer.childNodes[@endOffset - 1]
        r.end = Util.getLastTextNodeUpTo node
        r.endOffset = r.end.nodeValue.length

    else # We are dealing with simple text nodes
      r.end = @endContainer
      r.endOffset = @endOffset

    # We have collected the initial data.

    # Now let's start to slice & dice the text elements!
    nr = {}

    if r.startOffset > 0
      # Do we really have to cut?
      if r.start.nodeValue.length > r.startOffset
        # Yes. Cut.
        nr.start = r.start.splitText(r.startOffset)
      else
        # Avoid splitting off zero-length pieces.
        nr.start = r.start.nextSibling
    else
      nr.start = r.start

    # is the whole selection inside one text element ?
    if r.start is r.end
      if nr.start.nodeValue.length > (r.endOffset - r.startOffset)
        nr.start.splitText(r.endOffset - r.startOffset)
      nr.end = nr.start
    else # no, the end of the selection is in a separate text element
      # does the end need to be cut?
      if r.end.nodeValue.length > r.endOffset
        r.end.splitText(r.endOffset)
      nr.end = r.end

    # Make sure the common ancestor is an element node.
    nr.commonAncestor = @commonAncestorContainer
    while nr.commonAncestor.nodeType isnt Node.ELEMENT_NODE
      nr.commonAncestor = nr.commonAncestor.parentNode

    new Range.NormalizedRange(nr)

# Public: A normalised range is most commonly used throughout the annotator.
# its the result of a deserialised SerializedRange or a BrowserRange with
# out browser inconsistencies.
class Range.NormalizedRange

  # Public: Creates an instance of a NormalizedRange.
  #
  # This is usually created by calling the .normalize() method on one of the
  # other Range classes rather than manually.
  #
  # obj - An Object literal. Should have the following properties.
  #       commonAncestor: A Element that encompasses both the start and end nodes
  #       start:          The first TextNode in the range.
  #       end             The last TextNode in the range.
  #
  # Returns an instance of NormalizedRange.
  constructor: (obj) ->
    @commonAncestor = obj.commonAncestor
    @start          = obj.start
    @end            = obj.end

  # Public: Fetches only the text nodes within th range.
  #
  # Returns an Array of TextNode instances.
  textNodes: ->
    textNodes = Util.getTextNodes($(this.commonAncestor))
    [start, end] = [textNodes.index(this.start), textNodes.index(this.end)]
    # Return the textNodes that fall between the start and end indexes.
    $.makeArray textNodes[start..end]
