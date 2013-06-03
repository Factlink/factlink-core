class window.FavouriteTopicButtonView extends ActionButtonView

  initialize: ->
    @user = currentUser

    @bindTo @model.favourite_topics, 'add remove change reset', =>
      checked = @model.get('slug_title') in @user.favourite_topics.pluck('slug_title')
      @stateModel.set 'checked', checked

    @bindTo @stateModel, 'click:unchecked', => @model.favourite()
    @bindTo @stateModel, 'click:checked', => @model.unfavourite()

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_topic.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()
