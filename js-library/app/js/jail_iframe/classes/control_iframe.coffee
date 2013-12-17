
class ControlIframe
  constructor: ->
    @el = document.createElement('iframe');
    #need to append to outer document before we can access frame document.
    FactlinkJailRoot.$factlinkCoreContainer.append(@el)
    @doc = @el.contentWindow.document;
    @doc.open()
    #need doctype to avoid quirks mode
    @doc.write('<!DOCTYPE html><title></title>')
    @doc.close()
    style = @doc.createElement('style')
    style.appendChild(@doc.createTextNode(FrameCss))
    @doc.head.appendChild(style)

  destroy: ->
    return unless @el
    @doc = null
    @el.parentElement?.removeChild(@el)
    @el = null
