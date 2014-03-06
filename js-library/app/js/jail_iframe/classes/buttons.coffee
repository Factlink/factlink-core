class FactlinkJailRoot.CreateButton
  content: """
    <div class="fl-button"><span class="fl-button-icon"></span></div>
  """

  constructor: ->
    @frame = new FactlinkJailRoot.ControlIframe(@content)
    @$el = $(@frame.frameBody.firstChild)

    @_robustHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      $externalDocument: $(document)
      mouseenter: => @frame.addClass 'hovered'
      mouseleave: => @frame.removeClass 'hovered'

    @$el.on 'mousedown', (event) -> event.preventDefault() # To prevent de-selecting text
    @$el.on 'click', @_onClick

  _onClick: (event) =>
    FactlinkJailRoot.createFactFromSelection()

  placeNearSelection: (mouseX=null) ->
    return if @_visible

    selectionBox = window.document.getSelection().getRangeAt(0).getBoundingClientRect()
    selectionLeft = selectionBox.left + $(window).scrollLeft()
    selectionTop = selectionBox.top + $(window).scrollTop()
    buttonWidth = @frame.$el.outerWidth()

    if mouseX
      left = Math.min Math.max(mouseX, selectionLeft+buttonWidth/2),
        selectionLeft+selectionBox.width-buttonWidth/2
    else
      left = selectionLeft + selectionBox.width/2

    left -= buttonWidth/2
    top = selectionTop-2-@frame.$el.outerHeight()

    @_visible = true
    @frame.fadeIn()
    @frame.setOffset
      top: top
      left: left

  hide: =>
    @frame.fadeOut()
    @_visible = false

FactlinkJailRoot.host_ready_promise.then ->
  FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton
