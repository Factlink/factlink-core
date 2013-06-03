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
    @bindTo @stateModel(), 'click:unchecked', =>
      @model.user_topics().invoke 'favourite'

  onClick: -> @stateModel().onClick()
  onMouseEnter: -> @stateModel().set 'hovering', true
  onMouseLeave: -> @stateModel().set 'hovering', false

  onRender: ->
    @buttonRegion.show @followUserButton()

    @bindTo @stateModel(), 'change:checked', =>
      @$el.toggleClass 'secondary', @stateModel().get('checked')

    @bindTo @stateModel(), 'change:hovering', =>
      @$el.toggleClass 'hover', @stateModel().get('hovering')

  stateModel: ->
    @followUserButton().stateModel

  followUserButton: ->
    @_followUserButton ?= new FollowUserButtonView
      model: @model
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
