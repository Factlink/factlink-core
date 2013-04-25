class window.FavouriteTopicButtonView extends ActionButtonView
  mini: true

  onRender: -> @updateButton()

  initialize: ->
    @bindTo @model, 'change', @updateButton, @
    @user = currentUser

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  buttonEnabled: ->
    @user.favourite_topics.contains @model

  primaryAction: (e) ->
    @model.favourite()

  secondaryAction: (e) ->
    @model.unfavourite()
