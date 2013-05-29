class window.FavouriteTopicButtonView extends ActionButtonView

  initialize: ->
    @user = currentUser
    @bindTo @user.favourite_topics, 'add remove change reset', @updateButton, @

  templateHelpers: =>
    disabled_label: Factlink.Global.t.follow_topic.capitalize()
    disable_label:  Factlink.Global.t.unfollow.capitalize()
    enabled_label:  Factlink.Global.t.following.capitalize()

  buttonEnabled: ->
    @model.get('slug_title') in @user.favourite_topics.pluck('slug_title')

  primaryAction: (e) ->
    @model.favourite()

  secondaryAction: (e) ->
    @model.unfavourite()

  onRender: -> @updateButton()
