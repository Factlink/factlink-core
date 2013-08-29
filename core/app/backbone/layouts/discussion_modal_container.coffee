class window.DiscussionModalContainer extends Backbone.Marionette.Layout
  className: 'discussion-modal-container'
  template: 'layouts/discussion_modal_container'

  regions:
    mainRegion: '.js-modal-content'

  events:
    'click': 'onClick'
    'click .js-client-html-close': 'onClickButton'

  onClick: (event) ->
    return unless @$el.is(event.target)

    FactlinkApp.vent.trigger 'close_discussion_modal'

  onClickButton: ->
    mp_track "Modal: Close button"
    FactlinkApp.vent.trigger 'close_discussion_modal'

  onRender: -> @$el.preventScrollPropagation()
