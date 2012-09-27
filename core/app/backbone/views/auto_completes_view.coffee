class SteppableView extends Backbone.Marionette.CompositeView
  initialize: -> @list = [];
  closeList: -> @list = [];

  onClose: -> @closeList()

  activeChannelKey: -> @_activeChannelKey
  setActiveChannelKey: (value)-> @_activeChannelKey = value

  deActivateCurrent: () ->
    if ( @list[@activeChannelKey()] )
      @list[@activeChannelKey()].trigger('deactivate');

  fixKeyModulo: (key)->
    maxval = @list.length - 1;


    key = 0 if (key > maxval)
    key = maxval if (key < 0)

    return key

  setActiveAutoComplete:  (key)->
    @deActivateCurrent()
    key = this.fixKeyModulo(key)

    @list[key].trigger('activate');

    @setActiveChannelKey(key)

  moveSelectionUp: ->
    prevKey = if @activeChannelKey()? then @activeChannelKey() - 1 else -1
    this.setActiveAutoComplete(prevKey, true)

  moveSelectionDown: ->
    nextKey = if @activeChannelKey()? then this.activeChannelKey() + 1 else 0
    this.setActiveAutoComplete(nextKey, true)

  onItemAdded: (view)->
    view.on 'close', =>
      i = @list.indexOf(view)
      @list.splice(i,1)

    view.on 'requestActivate', =>
      unless @alreadyHandlingAnActivate
        @alreadyHandlingAnActivate = true
        i = @list.indexOf(view)
        @setActiveAutoComplete(i)
        @alreadyHandlingAnActivate = false

    view.on 'requestDeActivate', => @deActivateCurrent()

    @list.push(view)

  currentActiveModel: ->
    if 0 <= @activeChannelKey() < @list.length
      @list[@activeChannelKey()].model
    else
     `undefined`

class window.AutoCompletesView extends SteppableView
  template: "channels/_auto_completes"

  itemViewContainer: 'ul.existing-container'
  itemView: AutoCompletedChannelView

  className: 'auto_complete'

  itemViewOptions: =>
    return {
      query: @options.mainView._lastKnownSearchValue,
      parent: @options.mainView
    }

  initialize: ->
    super()
    @search_collection = new TopicSearchResults()
    @collection = collectionDifference(TopicSearchResults,
      'slug_title', @search_collection, @options.alreadyAdded)

    @search_collection.on 'reset', =>
      @setActiveChannelKey `undefined`
      @setActiveAutoComplete 0

  onClose: -> super()

  onItemAdded: (view)-> super(view)

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index