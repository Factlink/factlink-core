
class ControlIframe
  constructor: ->
    console.log('creating frame')
    @el = document.createElement('iframe')
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

  setContent: (contentNode) ->
    bodyEl = @doc.body
    while bodyEl.firstChild
      bodyEl.removeChild(bodyEl.firstChild)
    bodyEl.appendChild(contentNode)
    @resizeFrame()

  resizeFrame: ->
    console.log('resizing frame')
    @el.style.width = @doc.body.clientWidth  + 'px'
    @el.style.height = @doc.body.clientHeight + 'px'

  destroy: ->
    return unless @el
    @doc = null
    @el.parentElement?.removeChild(@el)
    @$el = @el = null
