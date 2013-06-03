# We might want to look into refactoring ActionButtonView to use a model so we
# can reuse state and state transitions of the model instead of overriding
# a lot of methods.
class TourUserView extends Backbone.Marionette.Layout

  _.extend @prototype, Backbone.Factlink.TooltipMixin

  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  events:
    "click":   "onClick"
    "mouseenter": "onMouseEnter"
    "mouseleave": "onMouseLeave"

  regions:
    buttonRegion: '.js-region-button'

  initialize: ->
    @bindTo @actionButtonModel(), 'click:unchecked', =>
      @model.user_topics().invoke 'favourite'

  onClick: -> @actionButtonModel().onClick()
  onMouseEnter: -> @actionButtonModel().set 'hovering', true
  onMouseLeave: -> @actionButtonModel().set 'hovering', false

  onRender: ->
    @buttonRegion.show @followUserButton()

    @bindTo @actionButtonModel(), 'change:checked', =>
      @$el.toggleClass 'secondary', @actionButtonModel().get('checked')

    @bindTo @actionButtonModel(), 'change:hovering', =>
      @$el.toggleClass 'hover', @actionButtonModel().get('hovering')

  actionButtonModel: ->
    @followUserButton().model

  followUserButton: ->
    @_followUserButton ?= new FollowUserButtonView
      user: @model
      noEvents: true

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
