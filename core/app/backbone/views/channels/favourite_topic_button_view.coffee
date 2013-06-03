class window.FavouriteTopicButtonView extends ActionButtonView

  initialize: ->
    @user = currentUser

    @bindTo @stateModel, 'click:unchecked', => @model.favourite()
    @bindTo @stateModel, 'click:checked', => @model.unfavourite()

    @bindTo @user.favourite_topics, 'add remove change reset', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    _.extend super,
      disabled_label: Factlink.Global.t.follow_topic.capitalize()
      disable_label:  Factlink.Global.t.unfollow.capitalize()
      enabled_label:  Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    checked = @model.get('slug_title') in @user.favourite_topics.pluck('slug_title')
    @stateModel.set 'checked', checked
