#= require ./composite_view

# TODO: refactor this as a mixin which uses events instead of method overloading
window.extendWithAutoloading = (superclass) ->
  superclass.extend
    constructor: (args...) ->
      result = superclass::constructor.apply(this, args)

      @collection.loadMore()
      @collection.on "add", @emptyViewOffWrapper, @
      @collection.on "remove stopLoading", @afterLoad, @

      result

    bottomOfViewReached: ->
      bottomOfTheViewport = window.pageYOffset + window.innerHeight
      bottomOfEl = @$el.offset().top + @$el.outerHeight()

      if bottomOfEl < bottomOfTheViewport
        true
      else if $(document).height() - ($(window).scrollTop() + $(window).height()) < 700
        true
      else
        false
    
    # this function sets the correct state after loading is done, tries to load more if applicable
    # and sets empty state if we are not loading and we have no items
    afterLoad: ->
      unless @collection._loading
        @emptyViewOnWrapper()  if @collection.length is 0
        @collection.loadMore() if @bottomOfViewReached()

    bindScroll: ->
      @unbindScroll()

      $(window).on "scroll.#{@cid}", =>
        @afterLoad() if @$el.is(":visible")

    unbindScroll: ->
      $(window).off "scroll.#{@cid}"

    close: (args...) ->
      result = superclass::close.apply(this, args)
      @unbindScroll()
      result

    render: (args...) ->
      result = superclass::render.apply(this, args)
      @bindScroll()
      result

    reset: (args...) ->
      @collection.stopLoading()
      superclass::reset.apply(this, args)

    emptyViewOnWrapper: ->
      unless "_emptyViewIsOn" of this
        @emptyViewOn()
        @_emptyViewIsOn = true

    emptyViewOffWrapper: ->
      if "_emptyViewIsOn" of this
        @emptyViewOff()
        delete @_emptyViewIsOn

    
    # TODO: replace this by standard empty view functionality by marionette.
    emptyViewOn: ->

    emptyViewOff: ->

window.AutoloadingCompositeView = extendWithAutoloading(Backbone.Factlink.CompositeView)
