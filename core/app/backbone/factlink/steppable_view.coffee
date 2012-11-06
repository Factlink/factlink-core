Backbone.Factlink ||= {}
class Backbone.Factlink.SteppableView extends Backbone.Marionette.CompositeView
  constructor: (args...)->
    super(args...)
    @on 'item:added', @onItemAddedDoSteppableInitialization, this
    @list = []

  closeList: -> @list = []

  close: (args...)->
    super(args...)
    @closeList()

  deActivateCurrent: () ->
    @currentActiveView()?.trigger('deactivate');
    @activeViewKey = `undefined`

  fixKeyModulo: (key)->
    if key >= @list.length then 0
    else if key < 0 then @list.length - 1
    else key

  setActiveView:  (key)->
    @deActivateCurrent()
    key = @fixKeyModulo(key)
    view = @list[key]
    if view
      view.trigger('activate');
      @activeViewKey = key

  moveSelectionUp: ->
    prevKey = if @activeViewKey? then @activeViewKey - 1 else -1
    @setActiveView prevKey

  moveSelectionDown: ->
    nextKey = if @activeViewKey? then @activeViewKey + 1 else 0
    @setActiveView nextKey

  onItemAddedDoSteppableInitialization: (view)->
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
