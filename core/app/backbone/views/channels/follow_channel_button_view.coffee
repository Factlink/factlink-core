class window.FollowChannelButtonView extends ActionButtonView

  initialize: ->
    @bindTo @model, 'click:unchecked', => @options.channel.follow()
    @bindTo @model, 'click:checked', => @options.channel.unfollow()

    @bindTo @options.channel, 'change', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    unchecked_label:         Factlink.Global.t.follow.capitalize()
    checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
    checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    @model.set 'checked', @options.channel.get('followed?')
