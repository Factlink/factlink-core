class TourUserView extends ActionButtonView

  _.extend @prototype, Backbone.Factlink.TooltipMixin

  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_user.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  enableHoverState: ->
    super and
      @$el.addClass 'hover'

  disableHoverState: ->
    super
    @$el.removeClass 'hover'

  updateButton: ->
    super
    @$el.toggleClass 'secondary', @buttonEnabled()

  buttonEnabled: ->
    @model.followers.followed_by_me()

  primaryAction: ->
    @model.follow()
    @$el.removeClass 'hover'
    @model.user_topics().invoke 'favourite'
    @updateButton()

  secondaryAction: ->
    @model.unfollow()
    @$el.removeClass 'hover'
    @updateButton()

  authorityPopover: ->
    unless @_authorityPopover?
      @_authorityPopover = new TourAuthorityPopoverView
      @bindTo @_authorityPopover, 'next', @tooltipResetAll
    @_authorityPopover

  showAuthorityPopover: ->
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
