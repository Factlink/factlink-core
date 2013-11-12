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
    mp_track 'Discussion Modal: Close'

  onRender: ->
    @$el.preventScrollPropagation()
    _.defer => @$el.addClass 'discussion-modal-container-visible'
    mp_track 'Discussion Modal: Open'

  fadeOut: (callback) ->
    @$el.removeClass 'discussion-modal-container-visible'
    _.delay callback, 100 # keep in sync with CSS
