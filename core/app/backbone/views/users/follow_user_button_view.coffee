class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @bindTo @model.followers, 'change', @updateButton, @

  templateHelpers: =>
    primary_action_label:   Factlink.Global.t.follow.capitalize()
    hover_state_label:      Factlink.Global.t.unfollow.capitalize()
    secondary_action_label: Factlink.Global.t.following.capitalize()

  buttonState: ->
    @model.followers.followed_by_me()

  primaryAction: (e) ->
    @model.follow()
    e.preventDefault()
    e.stopPropagation()

  secondaryAction: (e) ->
    @model.unfollow()
    e.preventDefault()
    e.stopPropagation()
