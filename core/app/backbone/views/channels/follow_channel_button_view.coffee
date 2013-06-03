class window.FollowChannelButtonView extends ActionButtonView

  initialize: ->
    @bindTo @model, 'change', =>
      @stateModel.set 'checked', @model.get('followed?')

    @bindTo @stateModel, 'click:unchecked', => @model.follow()
    @bindTo @stateModel, 'click:checked', => @model.unfollow()

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()
