class window.UserChannelSuggestionsView extends Backbone.Marionette.CompositeView
  template: "channels/_suggested_user_channels"

  className: 'tourSuggestions'

  itemViewContainer: "ul",

  itemView: UserChannelSuggestionView

  itemViewOptions: =>
    addToCollection: @options.addToCollection
    addToActivities: @options.addToActivities

  initialize: (options)->
    @collection =  collectionDifference(new ChannelList, 'slug_title', @collection, options.addToCollection);
    @on 'itemview:added', => @trigger 'added'
    @collection.on 'reset', this.checkSuggestionsEmpty, this
    @checkSuggestionsEmpty()

  checkSuggestionsEmpty: ->
    @trigger 'no_suggestions' if @collection.length == 0


  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()
