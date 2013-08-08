class window.FollowUserButtonView extends ActionButtonView
  className: 'user-follow-user-button'

  initialize: ->
    @listenTo @model, 'click:unchecked', -> @options.user.follow()
    @listenTo @model, 'click:checked', -> @options.user.unfollow()

    @listenTo currentUser, 'follow_action', @updateStateModel
    @updateStateModel()

    currentUser.following.fetchOnce
      success: => @model.set loaded: true

  templateHelpers: =>
    unchecked_label:         Factlink.Global.t.follow_user.capitalize()
    checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
    checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    @model.set 'checked', @options.user.followed_by_me()
