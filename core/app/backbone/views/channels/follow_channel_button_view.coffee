class window.FollowChannelButtonView extends ActionButtonMiniView

  initialize: ->
    @bindTo @model, 'change', @updateButton, @

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow
    disable_label:  Factlink.Global.t.unfollow
    enabled_label:  Factlink.Global.t.following

  buttonEnabled: ->
    @model.get('followed?')

  primaryAction: (e) ->
    @model.follow()

  secondaryAction: (e) ->
    @model.unfollow()

  onRender: -> @updateButton()
