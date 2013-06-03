class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @bindTo @model.followers, 'change', =>
      @stateModel.set 'checked', @model.followers.followed_by_me()

    @bindTo @stateModel, 'click:unchecked', => @model.follow()
    @bindTo @stateModel, 'click:checked', => @model.unfollow()

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_user.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()
