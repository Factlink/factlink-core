class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @bindTo @model.followers, 'all', @updateButton, @

    currentUser.following.fetch()

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_user.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  buttonEnabled: ->
    @model.followed_by_me()

  primaryAction: (e) ->
    @model.follow()

  secondaryAction: (e) ->
    @model.unfollow()
