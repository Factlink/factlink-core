class window.DiscussionModalContainer extends Backbone.Marionette.Layout
  className: 'discussion-modal-container'
  template: 'layouts/discussion_modal_container'

  regions:
    mainRegion: '.js-modal-content'

  events:
    'click': 'closeModal'

  ui:
    close: '.js-client-html-close'

  closeModal: (event) ->
    return unless @$el.is(event.target) || @ui.close.is(event.target)

    FactlinkApp.vent.trigger 'close_discussion_modal'

  onRender: -> @$el.preventScrollPropagation()
