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

  setActiveAutoComplete:  (key, scroll=true)->
    this.options.mainView.deActivateCurrent()
    key = this.fixKeyModulo(key)

    console.info "SETTING ACTIVE TO", key, @list.length

    if 0 <= key < @list.length
      @list[key].trigger('activate');

      if (  scroll == true)
        list = @$("ul")[0];
        if (list.scrollHeight > list.clientHeight)
          @list[key].el.scrollIntoView(scroll)


    else
      @options.mainView.activateAddNew()

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


    @list.push(view)





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

    @search_collection.on 'reset', -> @addNewItem()


  onClose: -> super()

  onItemAdded: (view)->
    super(view)
    @options.mainView.$('.auto_complete').removeClass('empty')

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index