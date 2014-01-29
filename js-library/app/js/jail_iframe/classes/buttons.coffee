class FactlinkJailRoot.CreateButton
  content: """
    <div class="fl-button fl-button-black fl-button-with-arrow-down">
      <div class="fl-button-content-default">
        <span class="icon-comment"></span>
      </div>
      <div class="fl-button-content-hovered">
        <span class="icon-comment"></span>
        <span class="fl-button-sub-button" data-opinion="believes"><span class="icon-thumbs-up"></span></span><span class="fl-button-sub-button" data-opinion="disbelieves"><span class="icon-thumbs-down"></span></span>
      </div>
      <div class="fl-button-content-loading">Loading...</div>
    </div>
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

  startLoading: => @frame.addClass 'loading'
  stopLoading: => @frame.removeClass 'loading hovered'

  _onClick: (event) =>
    @startLoading()
    current_user_opinion = $(event.target).closest('[data-opinion]').data('opinion')
    FactlinkJailRoot.createFactFromSelection(current_user_opinion)

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

FactlinkJailRoot.core_loaded_promise.then ->
  FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton
