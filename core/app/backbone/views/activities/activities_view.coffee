AutoloadingView = extendWithAutoloading(Backbone.Marionette.Layout);

class FeedEmptyView extends Backbone.Marionette.ItemView
  className: 'empty_stream_content'
  template:
    text: "Currently there are no activities in your #{Factlink.Global.t.stream} yet. Please use the search in the top bar to find interesting users and topics to follow."

class window.ActivitiesView extends AutoloadingView
  _.extend @prototype, ToggleMixin

  template: 'activities/list'

  regions:
    bottomRegion: '.js-region-bottom'

  initialize: (opts) ->
    @collection.on 'reset remove', @reset, @
    @collection.on 'add', @add, @

    @addShowHideToggle 'loadingIndicator', 'div.loading'
    @collection.on 'startLoading', @loadingIndicatorOn, @
    @collection.on 'stopLoading', @loadingIndicatorOff, @

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
    lastChildView = _.last(@childViews)

    unless lastChildView?.tryAppend(model)
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

  newChildView: (model) ->
    ch = @collection.channel
    ActivitiesGroupView.new
      model: model

  emptyViewOn: ->
    unless @options.disableEmptyView
      @someEmptyView = new FeedEmptyView
      @$('.js-empty-stream').html @someEmptyView.render().el

  emptyViewOff: ->
    if @someEmptyView?
      @someEmptyView.close()
      delete @someEmptyView

  addAtBottom:(view) -> @bottomRegion.show view
