FactlinkApp.module "ModalWindowContainer", (ModalWindowContainer, MyApp, Backbone, Marionette, $, _) ->

  class ModalWindowContainer.WrapperView extends Backbone.Marionette.Layout
    className: 'modal-window-container'
    template: 'widgets/modal_window_wrapper'

    events:
      "click .js-layer": "fadeOut"
      "click": "stopPropagation"

    regions:
      modalRegion: '.js-modal-region'

    onRender: ->
      @modalRegion.show @options.content_view
      @$el.fadeIn 'fast'
      @$el.preventScrollPropagation()

    stopPropagation: (e) ->
      e.stopPropagation()

    fadeOut: ->
      @$el.fadeOut 'fast', =>
        @modalRegion.close()

  FactlinkApp.addRegions
    modalRegion: "#modal_region"

  # This assumes that we use "navigate url, true" for all url changes that
  # originate from the discussion modal
  FactlinkApp.vent.on 'load_url', ->
    ModalWindowContainer.close()

  ModalWindowContainer.show = (content_view)->
    @_wrapped_view = new FactlinkApp.ModalWindowContainer.WrapperView
      content_view: content_view

    FactlinkApp.modalRegion.show @_wrapped_view

  ModalWindowContainer.close = ->
    @_wrapped_view?.fadeOut()
