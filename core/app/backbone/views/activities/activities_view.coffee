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
      unless @collection._loading or not @$el.is(":visible")
        @emptyViewOnWrapper()  if @collection.length is 0
        @collection.loadMore() if @bottomOfViewReached()

    bindScroll: ->
      @unbindScroll()

      $(window).on "scroll.#{@cid}", =>
        @afterLoad()

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
    emptyViewOffWrapper: ->

AutoloadingView = extendWithAutoloading(Backbone.Marionette.Layout);

class window.ActivitiesView extends AutoloadingView
  template: 'activities/list'

  regions:
    bottomRegion: '.js-region-bottom'

  initialize: (opts) ->
    @collection.on 'reset remove', @reset, @
    @collection.on 'add', @add, @

    @childViews = []

  onRender: ->
    @renderChildren()

  renderChildren: ->
    @$('.js-activities-list').html('')
    for childView in @childViews
      @appendHtml @, childView

  reset: ->
    @closeChildViews()
    @collection.each @add, @
    @renderChildren()

  add: (model, collection, options) ->
    @createNewChildView(model)

  createNewChildView: (model) ->
    appendTo = @newChildView(model)
    @childViews.push appendTo
    @appendHtml @, appendTo

  closeChildViews: ->
    childView.close() for childView in @childViews
    @childViews = []

  onBeforeClose: -> @closeChildViews()

  appendHtml: (collectionView, childView, index) ->
    @$(".js-activities-list").append childView.render().el
    childView.trigger 'show'

  newChildView: (model) ->
    component = switch model.get("action")
      when "created_comment", "created_sub_comment"
        ReactCreatedComment
      when "followed_user"
        ReactFollowedUser

    new ReactView
      component: component
        model: model

  addAtBottom:(view) -> @bottomRegion.show view
