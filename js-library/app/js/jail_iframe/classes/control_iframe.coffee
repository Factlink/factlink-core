control_visibility_transition_time = 300+1000/60 #keep in sync with scss

# future work: ideally, we'd help consumers of this class to load
# complete dom fragments including event hooks into the frame,
# thus avoiding then need for frame introspection.

class FactlinkJailRoot.ControlIframe
  constructor: (contentHtml) ->
    @el = document.createElement('iframe')
    @el.className = 'factlink-control-frame'
    #need to append to outer document before we can access frame document.
    FactlinkJailRoot.$factlinkCoreContainer.append(@el)
    @$el = $(@el)
    @doc = @el.contentWindow.document;
    @doc.open()
    #need doctype to avoid quirks mode
    @doc.write('<!DOCTYPE html><title></title>')
    @doc.close()
    style = @doc.createElement('style')
    style.appendChild(@doc.createTextNode(jail_window.FrameCss))
    #explicitly set variables on jail_window aren't implicitly in scope in IE11 in the jail frame's code; need to explicitly resolve.
    @doc.head.appendChild(style)
    @frameBody = @doc.body
    @$frameBody = $(@doc.body)

    @frameBody.innerHTML = '';
    @frameBody.appendChild $.parseHTML(contentHtml.trim())[0]
    @_sizeFrameToFitContent()

  _sizeFrameToFitContent: ->
    @el.style.width = @frameBody.clientWidth  + 'px'
    @el.style.height = @frameBody.clientHeight + 'px'

    # Also resize the frame <html> itself for iOS Safari,
    # which resizes iframes themselves based on their inner size
    @frameBody.parentElement.style.width = @frameBody.clientWidth  + 'px'

  fadeIn: ->
    @$el.addClass 'factlink-control-visible'
    FactlinkJailRoot.delay control_visibility_transition_time

  fadeOut: ->
    @$el.removeClass 'factlink-control-visible'
    FactlinkJailRoot.delay control_visibility_transition_time

  destroy: ->
    return unless @el
    @doc = null
    @el.parentElement?.removeChild(@el)
    @$el = @el = null

  addClass: (classes) =>
    @$frameBody.addClass classes
    @_sizeFrameToFitContent()

  removeClass: (classes) =>
    @$frameBody.removeClass classes
    @_sizeFrameToFitContent()

  setOffset: (coordinates) =>
    FactlinkJailRoot.setElementPosition
      $el: @$el
      left: coordinates.left
      top: coordinates.top
