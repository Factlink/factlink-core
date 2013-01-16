FactlinkApp.module "Modal", (Modal, MyApp, Backbone, Marionette, $, _) ->

  class Modal.WrapperView extends Backbone.Marionette.Layout
    template:
      text: """
        <div class="modal">
          <div class="modal-header">
            <button type="button" class="close close-popup">&times;</button>
            <h3>{{title}}</h3>
          </div>
          <div class="modal-body">
          </div>
        </div>
        <div class="transparent-layer"></div>
      """

    events:
      "click .close-popup": "close"
      "click": "stopPropagation"

    regions:
      modalRegion: '.modal-body'

    templateHelpers: =>
      title: @options.title

    onRender: ->
      @modalRegion.show @options.content_view
      @$('.modal').show()
      @$('.transparent-layer').show()

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
