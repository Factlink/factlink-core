# We might want to look into refactoring ActionButtonView to use a model so we
# can reuse state and state transitions of the model instead of overriding
# a lot of methods.
class TourUserView extends ActionButtonView

  _.extend @prototype, Backbone.Factlink.TooltipMixin

  template: 'tour/interesting_user'
  className: 'tour-interesting-user action-button'

  initialize: ->
    @bindTo @model.followers, 'change', =>
      @stateModel.set 'checked', @model.followers.followed_by_me()

    @bindTo @stateModel, 'click:unchecked', =>
      @model.follow()
      @model.user_topics().invoke 'favourite'
    @bindTo @stateModel, 'click:checked', => @model.unfollow()

    @bindTo @stateModel, 'change:checked', =>
      @$el.toggleClass 'secondary', @stateModel.get('checked')

    @bindTo @stateModel, 'change:hovering', =>
      @$el.toggleClass 'hover', @stateModel.get('hovering')

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_user.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

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
