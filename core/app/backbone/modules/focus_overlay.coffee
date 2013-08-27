FactlinkApp.module "FocusOverlay", (FocusOverlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_elements = $('<div class="focus-overlay"></div><div class="focus-overlay-transparent"></div>')
    .appendTo('body')

  $focus_el = null

  FocusOverlay.show = ($el) ->
    $overlay_elements.fadeTo 'fast', 1

    FocusOverlay.removeFocus()
    $focus_el = $el
    $focus_el.addClass 'focus-overlay-element'

  FocusOverlay.hide = ->
    FocusOverlay.removeFocus()
    $overlay_elements.fadeOut 'fast'

  FocusOverlay.removeFocus = ->
    $focus_el?.removeClass 'focus-overlay-focus'
