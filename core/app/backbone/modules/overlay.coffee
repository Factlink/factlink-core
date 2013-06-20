FactlinkApp.module "Overlay", (Overlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_elements = $('<div class="modal-overlay"></div><div class="modal-overlay-transparent"></div>')
    .appendTo('#body')

  Overlay.show = ->
    $overlay_elements.fadeIn(300)

  Overlay.hide = ->
    $overlay_elements.fadeOut(300)
