FactlinkApp.module "ModalWindowContainer", (ModalWindowContainer, MyApp, Backbone, Marionette, $, _) ->

  class ModalWindowContainer.WrapperView extends Backbone.Marionette.Layout
    template: 'widgets/modal_window_wrapper'

    events:
      "click .js-layer": "fadeOut"
      "click": "stopPropagation"

    regions:
      modalRegion: '.js-modal-region'

    ui:
      modalRegion: '.js-modal-region'
      layer: '.js-layer'

    onRender: ->
      @modalRegion.show @options.content_view
      @ui.modalRegion.fadeIn 'fast'
      @ui.layer.fadeIn 'fast'

    stopPropagation: (e) ->
      e.stopPropagation()

    # We cannot fade the wrapping region, e.g. using a CrossFadeRegion, because
    # that would create a stacking context, but currently @ui.modalRegion and @ui.layer
    # both have set z-indexes.
    fadeOut: ->
      @ui.layer.fadeOut 'fast'
      @ui.modalRegion.fadeOut 'fast', =>
        @modalRegion.close()

  FactlinkApp.addRegions
    modalRegion: "#modal_region"

  FactlinkApp.vent.on 'navigate load_url', ->
    ModalWindowContainer.close()

  ModalWindowContainer.show = (content_view)->
    @_wrapped_view = new FactlinkApp.ModalWindowContainer.WrapperView
      content_view: content_view

    FactlinkApp.modalRegion.show @_wrapped_view

  ModalWindowContainer.close = ->
    @_wrapped_view?.fadeOut()
