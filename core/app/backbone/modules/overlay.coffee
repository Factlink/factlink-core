FactlinkApp.module "Overlay", (Overlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_elements = $('<div class="overlay"></div><div class="overlay-transparent"></div>')
    .appendTo('body')

  Overlay.show = ->
    $overlay_elements.fadeIn 'fast'

  Overlay.hide = ->
    $overlay_elements.fadeOut 'fast'
