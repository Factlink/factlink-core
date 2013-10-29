class TourUserView extends Backbone.Marionette.Layout

  _.extend @prototype, Backbone.Factlink.PopoverMixin

  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  regions:
    buttonRegion: '.js-region-button'

  initialize: ->
    @listenTo @cloned_user(), 'followed', ->
      @model.user_topics().invoke 'favourite'

  onRender: ->
    @buttonRegion.show @followUserButton()

  followUserButton: ->
    unless @_followUserButton?
      @_followUserButton = new FollowUserButtonView
        user: @cloned_user()
        $listenToEl: @$el

      @listenTo @_followUserButton, 'render_state', (loaded, hovering, checked) ->
        @$el.toggleClass 'hover', hovering and loaded
        @$el.toggleClass 'secondary', checked and loaded
        @$el.toggleClass 'loaded', loaded

    @_followUserButton


  cloned_user: -> @_cloned_user ?= @model.clone()

  authorityPopover: ->
    unless @_authorityPopover?
      @_authorityPopover = new TourAuthorityPopoverView
      @listenTo @_authorityPopover, 'next', ->
        @popoverResetAll()
        FactlinkApp.FocusOverlay.hide()
    @_authorityPopover

  showAuthorityPopover: ->
    return if @model.user_topics().isEmpty()

    @popoverAdd '.js-topic',
      side: 'right'
      align: 'top'
      contentView: @authorityPopover()
      container: @$el.parent()
      popover_className: 'focus-overlay-popover factlink-popover'

    FactlinkApp.FocusOverlay.show @$('.js-topic').first()

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
  className: 'tour-interesting-users-list'
  emptyView: Backbone.Factlink.LoadingView

  onRender: ->
    @$el.toggleClass 'tour-interesting-users-list-empty', @collection.isEmpty()
