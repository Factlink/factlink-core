FactlinkApp.module "Overlay", (Overlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_elements = $('<div class="overlay"></div><div class="overlay-transparent"></div>')
    .appendTo('body')

  $focus_el = null

  Overlay.show = ($el=null) ->
    $overlay_elements.fadeIn 'fast'

    $focus_el = $el
    $focus_el?.addClass 'overlay-focus'


  Overlay.hide = ->
    $overlay_elements.fadeOut 'fast'
    $focus_el?.removeClass 'overlay-focus'
