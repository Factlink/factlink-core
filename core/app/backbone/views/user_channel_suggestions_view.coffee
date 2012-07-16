class window.UserChannelSuggestionsView extends Backbone.Marionette.CompositeView
  template: "channels/_related_channels",

  itemViewContainer: "ul",

  itemView: UserChannelSuggestionView

  itemViewOptions: => addToCollection : @options.addToCollection

  initialize: (options) ->
    @collection =  collectionDifference(ChannelList,'slug_title', @collection, options.addToCollection);

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()