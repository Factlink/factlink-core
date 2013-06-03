class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @bindTo @stateModel, 'click:unchecked', => @model.follow()
    @bindTo @stateModel, 'click:checked', => @model.unfollow()

    @bindTo @model.followers, 'change', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    _.extend super,
      unchecked_label:         Factlink.Global.t.follow_user.capitalize()
      checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
      checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    @stateModel.set 'checked', @model.followers.followed_by_me()
