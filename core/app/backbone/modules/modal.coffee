FactlinkApp.module "Modal", (Modal, MyApp, Backbone, Marionette, $, _) ->

  class Modal.WrapperView extends Backbone.Marionette.Layout
    template: 'widgets/modal_wrapper'

    events:
      "click .js-layer": "close"
      "click": "stopPropagation"

    regions:
      modalRegion: '.modal-body'

    templateHelpers: =>
      title: @options.title

    onRender: ->
      @modalRegion.show @options.content_view
      @$('.js-modal').show()
      @$('.js-layer').show()

    stopPropagation: (e) ->
      e.stopPropagation()

  FactlinkApp.addRegions
    modalRegion: "#modal_region"

  FactlinkApp.vent.on 'navigate load_url', ->
    Modal.close()

  Modal.show = (title, content_view)->
    wrapped_view = new FactlinkApp.Modal.WrapperView
      title: title
      content_view: content_view

    FactlinkApp.modalRegion.show wrapped_view

  Modal.close = ->
    FactlinkApp.modalRegion.close()
