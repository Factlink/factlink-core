class TourUserView extends ActionButtonView
  template: 'tour/interesting_user'
  className: 'tour-interesting-user'
  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_user.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  enableHoverState: ->
    return if @justClicked
    super
    @$el.addClass 'hover'

  disableHoverState: ->
    super
    @$el.removeClass 'hover'

  updateButton: ->
    super
    @$el.toggleClass 'secondary', @buttonEnabled()

  buttonEnabled: ->
    @somestate # TODO

  primaryAction: ->
    #TODO follow + favourite topics
    @somestate = true
    @updateButton()

  secondaryAction: ->
    #TODO unfollow
    @somestate = false
    @updateButton()

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
  className: 'tour-interesting-users-list'
