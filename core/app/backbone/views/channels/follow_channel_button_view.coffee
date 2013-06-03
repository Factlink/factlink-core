class window.FollowChannelButtonView extends ActionButtonView

  initialize: ->
    @bindTo @stateModel, 'click:unchecked', => @model.follow()
    @bindTo @stateModel, 'click:checked', => @model.unfollow()

    @bindTo @model, 'change', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    _.extend super,
      disabled_label: Factlink.Global.t.follow.capitalize()
      disable_label:  Factlink.Global.t.unfollow.capitalize()
      enabled_label:  Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    @stateModel.set 'checked', @model.get('followed?')
