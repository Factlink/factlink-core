class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @bindTo @model.followers, 'change', @updateButton, @

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  buttonEnabled: ->
    @model.followers.followed_by_me()

  primaryAction: (e) ->
    @model.follow()
    e.preventDefault()
    e.stopPropagation()

  secondaryAction: (e) ->
    @model.unfollow()
    e.preventDefault()
    e.stopPropagation()
