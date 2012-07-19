class window.UserChannelSuggestionsView extends Backbone.Marionette.CompositeView
  template: "channels/_suggested_user_channels"

  itemViewContainer: "ul",

  itemView: UserChannelSuggestionView

  itemViewOptions: =>
    addToCollection: @options.addToCollection
    addToActivities: @options.addToActivities

  initialize: (options) ->
    @collection =  collectionDifference(ChannelList,'slug_title', @collection, options.addToCollection);

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()