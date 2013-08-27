FactlinkApp.module "ModalWindow", (ModalWindow, MyApp, Backbone, Marionette, $, _) ->

  class ModalWindow.WrapperView extends Backbone.Marionette.Layout
    template: 'widgets/modal_window_wrapper'

    events:
      "click .js-layer": "fadeOut"
      "click": "stopPropagation"

    regions:
      modalRegion: '.js-modal-region'

    ui:
      modal: '.js-modal'
      layer: '.js-layer'

    templateHelpers: =>
      title: @options.title

    onRender: ->
      @modalRegion.show @options.content_view
      @ui.modal.fadeIn 'fast'
      @ui.layer.fadeIn 'fast'

    stopPropagation: (e) ->
      e.stopPropagation()

    # We cannot fade the wrapping region, e.g. using a CrossFadeRegion, because
    # that would create a stacking context, but currently @ui.modal and @ui.layer
    # both have set z-indexes.
    fadeOut: ->
      @ui.layer.fadeOut 'fast'
      @ui.modal.fadeOut 'fast', =>
        @modalRegion.close()

  FactlinkApp.addRegions
    modalRegion: "#modal_region"

  FactlinkApp.vent.on 'navigate load_url', ->
    ModalWindow.close()

  ModalWindow.show = (title, content_view)->
    @_wrapped_view = new FactlinkApp.ModalWindow.WrapperView
      title: title
      content_view: content_view

    FactlinkApp.modalRegion.show @_wrapped_view

  ModalWindow.close = ->
    @_wrapped_view?.fadeOut()
