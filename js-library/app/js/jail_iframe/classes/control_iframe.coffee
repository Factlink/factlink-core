control_visibility_transition_time = 300+1000/60 #keep in sync with scss

# future work: ideally, we'd help consumers of this class to load
# complete dom fragments including event hooks into the frame,
# thus avoiding then need for frame introspection.

class FactlinkJailRoot.ControlIframe
  constructor: ->
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
    style.appendChild(@doc.createTextNode(FrameCss))
    @doc.head.appendChild(style)
    @frameBody = @doc.body

  setContent: (contentNode) ->
    @frameBody.innerHTML = '';
    @frameBody.appendChild(contentNode)
    @sizeFrameToFitContent()

  sizeFrameToFitContent: ->
    @el.style.width = @frameBody.clientWidth  + 'px'
    @el.style.height = @frameBody.clientHeight + 'px'

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

