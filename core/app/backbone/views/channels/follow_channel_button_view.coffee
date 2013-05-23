class window.FollowChannelButtonView extends ActionButtonView

  initialize: ->
    @bindTo @model, 'change', @updateButton, @

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  buttonEnabled: ->
    @model.get('followed?')

  primaryAction: (e) ->
    @model.follow()

  secondaryAction: (e) ->
    @model.unfollow()

  onRender: -> @updateButton()
