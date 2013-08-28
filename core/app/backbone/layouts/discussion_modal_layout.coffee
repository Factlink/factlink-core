class window.DiscussionModalLayout extends Backbone.Marionette.Layout
  template: 'layouts/discussion_modal'

  regions:
    mainRegion: '.js-modal-content'

  events:
    'click .js-discussion-modal-layer': -> FactlinkApp.trigger 'close_discussion_modal'
    'click .js-client-html-close': -> mp_track "Modal: Close button"
