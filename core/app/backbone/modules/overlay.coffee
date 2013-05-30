FactlinkApp.module "Overlay", (Overlay, FactlinkApp, Backbone, Marionette, $, _) ->
  $overlay_element = $('<div></div>')
    .addClass('modal-overlay')
    .appendTo('body')

  Overlay.show = ->
    $overlay_element.show()

  Overlay.hide = ->
    $overlay_element.hide()
