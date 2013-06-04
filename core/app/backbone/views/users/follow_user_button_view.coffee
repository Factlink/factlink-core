class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    currentUser.following.fetch()
    @updates_bound = false

  onRender: ->
    @bindUpdates()
    @updateButton() # TODO remove, this should be behaviour
                    #      of ActionButtonView

  bindUpdates: ->
    return if @updates_bound
    @updates_bound = true

    @bindTo currentUser, 'follow_action', @updateButton, @

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
