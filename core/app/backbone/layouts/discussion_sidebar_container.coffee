class window.DiscussionSidebarContainer extends Backbone.Marionette.Layout
  className: 'discussion-sidebar-container spec-discussion-sidebar-container'
  template: 'layouts/discussion_sidebar_container'

  regions:
    mainRegion: '.js-modal-content'

  events:
    'click': '_closeModal'

  ui:
    close: '.js-client-html-close'

  _closeModal: (event) ->
    return unless @$el.is(event.target) || @ui.close.is(event.target)

    FactlinkApp.vent.trigger 'close_discussion_sidebar'

  onRender: ->
    @$el.preventScrollPropagation()

  slideIn: (view) ->
    _.defer => @$el.addClass 'discussion-sidebar-container-visible'
    @mainRegion.show view
    $('body').addClass 'discussion-sidebar-open'

    @opened = true
    mp_track 'Discussion Sidebar: Open'

  slideOut: (callback=->) ->
    @$el.removeClass 'discussion-sidebar-container-visible'
    $('body').removeClass 'discussion-sidebar-open'
    _.delay callback, @slide_transition_duration

    @opened = false
    mp_track 'Discussion Sidebar: Close'


  slide_transition_duration: 400  # keep in sync with CSS
