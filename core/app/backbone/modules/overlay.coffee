FactlinkApp.module "Overlay", (Overlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_elements = $('<div class="overlay"></div><div class="overlay-transparent"></div>')
    .appendTo('body')

  $focus_el = null

  Overlay.show = ($el) ->
    $overlay_elements.fadeIn 'fast'

    Overlay.removeFocus()
    $focus_el = $el
    $focus_el.addClass 'overlay-focus'

  Overlay.hide = ->
    Overlay.removeFocus()
    $overlay_elements.fadeOut 'fast'

  Overlay.removeFocus = ->
    $focus_el?.removeClass 'overlay-focus'
