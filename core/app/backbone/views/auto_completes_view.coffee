class SteppableView extends Backbone.Marionette.CompositeView
  initialize: -> @list = [];
  closeList: -> @list = [];

  onClose: -> @closeList()

  activeChannelKey: -> @activeViewKey
  setActiveChannelKey: (value)-> @activeViewKey = value

  deActivateCurrent: () ->
    @currentActiveView()?.trigger('deactivate');
    @activeViewKey = `undefined`

  fixKeyModulo: (key)->
    if key >= @list.length then 0
    else if key < 0 then @list.length -1
    else key

  setActiveView:  (key)->
    @deActivateCurrent()
    key = @fixKeyModulo(key)
    view = @list[key]
    if view
      view.trigger('activate');
      @setActiveChannelKey(key)

  moveSelectionUp: ->
    prevKey = if @activeChannelKey()? then @activeChannelKey() - 1 else -1
    this.setActiveView(prevKey, true)

  moveSelectionDown: ->
    nextKey = if @activeChannelKey()? then this.activeChannelKey() + 1 else 0
    this.setActiveView(nextKey, true)

  onItemAdded: (view)->
    view.on 'close', =>
      i = @list.indexOf(view)
      @list.splice(i,1)

    view.on 'requestActivate', =>
      unless @alreadyHandlingAnActivate
        @alreadyHandlingAnActivate = true
        i = @list.indexOf(view)
        @setActiveView(i)
        @alreadyHandlingAnActivate = false

    view.on 'requestDeActivate', => @deActivateCurrent()

    @list.push(view)

  currentActiveModel: -> @currentActiveView()?.model

  currentActiveView: ->
    if 0 <= @activeViewKey < @list.length
      @list[@activeViewKey]
    else
     `undefined`

class window.AutoCompletesView extends SteppableView
  template: "channels/_auto_completes"

  itemViewContainer: 'ul.existing-container'
  itemView: AutoCompletedChannelView

  className: 'auto_complete'

  itemViewOptions: =>
    return {
      query: @search_collection.query
      parent: @options.mainView
    }

  initialize: ->
    super()
    @search_collection = new TopicSearchResults()
    @collection = collectionDifference(TopicSearchResults,
      'slug_title', @search_collection, @options.alreadyAdded)

    @search_collection.on 'reset', => @setActiveView 0

  onClose: -> super()

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  onItemAdded: (view)-> super(view)

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index