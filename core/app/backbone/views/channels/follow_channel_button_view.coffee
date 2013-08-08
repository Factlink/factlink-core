class window.FollowChannelButtonView extends ActionButtonView

  initialize: ->
    @model.set loaded: true

    @listenTo @model, 'click:unchecked', -> @options.channel.follow()
    @listenTo @model, 'click:checked', -> @options.channel.unfollow()

    @listenTo @options.channel, 'change', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    unchecked_label:         Factlink.Global.t.follow.capitalize()
    checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
    checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    @model.set 'checked', @options.channel.get('followed?')
