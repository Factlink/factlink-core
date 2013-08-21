FactlinkApp.module "Modal", (Modal, MyApp, Backbone, Marionette, $, _) ->

  class Modal.WrapperView extends Backbone.Marionette.Layout
    template: 'widgets/modal_wrapper'

    events:
      "click .js-layer": "fadeOut"
      "click": "stopPropagation"

    regions:
      modalRegion: '.modal-body'

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
    Modal.close()

  Modal.show = (title, content_view)->
    @wrapped_view = new FactlinkApp.Modal.WrapperView
      title: title
      content_view: content_view

    FactlinkApp.modalRegion.show @wrapped_view

  Modal.close = ->
    @wrapped_view?.fadeOut()
