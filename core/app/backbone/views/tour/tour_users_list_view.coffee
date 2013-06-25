class TourUserView extends Backbone.Marionette.Layout

  _.extend @prototype, Backbone.Factlink.TooltipMixin

  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  regions:
    buttonRegion: '.js-region-button'

  initialize: ->
    @bindTo @cloned_user(), 'followed', =>
      @model.user_topics().invoke 'favourite'

  onRender: ->
    @buttonRegion.show @followUserButton()

  followUserButton: ->
    unless @_followUserButton?
      @_followUserButton = new FollowUserButtonView
        user: @cloned_user()
        listenToEl: @$el

      @bindTo @_followUserButton, 'render_state', (hovering, checked)=>
        @$el.toggleClass 'hover', hovering
        @$el.toggleClass 'secondary', checked

    @_followUserButton


  cloned_user: -> @_cloned_user ?= @model.clone()

  authorityPopover: ->
    unless @_authorityPopover?
      @_authorityPopover = new TourAuthorityPopoverView
      @bindTo @_authorityPopover, 'next', @tooltipResetAll
    @_authorityPopover

  showAuthorityPopover: ->
    return if @model.user_topics().isEmpty()

    @tooltipAdd '.js-topic', "What is this?", "",
      side: 'right'
      align: 'top'
      orthogonalOffset: -2
      contentView: @authorityPopover()
      show_overlay: true
      focus_on: @$('.js-topic')[0]
      container: @$el.parent()

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
  className: 'tour-interesting-users-list'
  emptyView: Backbone.Factlink.LoadingView

  onRender: ->
    @$el.toggleClass 'tour-interesting-users-list-empty', @collection.isEmpty()
