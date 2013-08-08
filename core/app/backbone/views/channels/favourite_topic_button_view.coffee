class window.FavouriteTopicButtonView extends ActionButtonView
  className: 'favourite-topic-button'

  initialize: ->
    @user = currentUser

    # TODO: invent some way to ensure favourite topics are actually loaded.
    # the current view seems to assume it already is loaded, so it wouldn't
    # need a loading state
    @model.set loaded: true

    @listenTo @model, 'click:unchecked', -> @options.topic.favourite()
    @listenTo @model, 'click:checked', -> @options.topic.unfavourite()

    @listenTo @user.favourite_topics, 'add remove change reset', @updateStateModel
    @updateStateModel()

  templateHelpers: =>
    unchecked_label:         Factlink.Global.t.follow_topic.capitalize()
    checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
    checked_unhovered_label: Factlink.Global.t.following.capitalize()

  updateStateModel: ->
    slug_title = @options.topic.get('slug_title')
    checked = slug_title in @user.favourite_topics.pluck('slug_title')
    @model.set 'checked', checked
