Backbone.Factlink ||= {}
class Backbone.Factlink.SteppableView extends Backbone.Marionette.CompositeView
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
