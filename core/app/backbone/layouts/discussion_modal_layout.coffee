class window.DiscussionModalLayout extends Backbone.Marionette.Layout
  className: 'discussion-modal-container'
  template: 'layouts/discussion_modal'

  regions:
    mainRegion: '.js-modal-content'

  events:
    'click': 'onClick'
    'click .js-client-html-close': 'onClickButton'

  onClick: (event) ->
    return unless event.target == @$el[0]

    FactlinkApp.trigger 'close_discussion_modal'

  onClickButton: ->
    mp_track "Modal: Close button"
    FactlinkApp.trigger 'close_discussion_modal'
