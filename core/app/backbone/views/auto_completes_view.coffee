class window.AutoCompletesView extends Backbone.Factlink.SteppableView
  template: "channels/_auto_completes"

  itemViewContainer: 'ul.existing-container'
  itemView: AutoCompletedChannelView

  className: 'auto_complete'

  itemViewOptions: =>
    query: @search_collection.query
    parent: @options.mainView

  initialize: ->
    @search_collection = new TopicSearchResults()
    @collection = collectionDifference(TopicSearchResults,
      'slug_title', @search_collection, @options.alreadyAdded)

    @search_collection.on 'reset', => @setActiveView 0

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index
