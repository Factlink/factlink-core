class window.FavouriteTopicButtonView extends ActionButtonView
  mini: true

  onRender: -> @updateButton()

  initialize: ->
    @user = currentUser
    @bindTo @user.favourite_topics, 'add remove change', @updateButton, @

  templateHelpers: =>
    disabled_label: Factlink.Global.t.favourite.capitalize()
    disable_label:  Factlink.Global.t.unfavourite.capitalize()
    enabled_label:  Factlink.Global.t.favourited.capitalize()

  buttonEnabled: ->
    # @model.id is the Topic slug_title
    @model.id in @user.favourite_topics.pluck('slug_title')

  primaryAction: (e) ->
    @model.favourite()

  secondaryAction: (e) ->
    @model.unfavourite()
