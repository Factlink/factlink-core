class window.FavouriteTopicButtonView extends ActionButtonView
  className: 'favourite-topic-button'

  initialize: ->
    @user = currentUser

    @bindTo @model, 'click:unchecked', => @options.topic.favourite()
    @bindTo @model, 'click:checked', => @options.topic.unfavourite()

    @bindTo @user.favourite_topics, 'add remove change reset', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    unchecked_label:         Factlink.Global.t.follow_topic.capitalize()
    checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
    checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    slug_title = @options.topic.get('slug_title')
    checked = slug_title in @user.favourite_topics.pluck('slug_title')
    @model.set 'checked', checked
