class window.FavouriteTopicButtonView extends ActionButtonView

  initialize: ->
    @user = currentUser

    @bindTo @stateModel, 'click:unchecked', => @model.favourite()
    @bindTo @stateModel, 'click:checked', => @model.unfavourite()

    @bindTo @user.favourite_topics, 'add remove change reset', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    _.extend super,
      unchecked_label:         Factlink.Global.t.follow_topic.capitalize()
      checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
      checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    checked = @model.get('slug_title') in @user.favourite_topics.pluck('slug_title')
    @stateModel.set 'checked', checked
