AutoloadingView = extendWithAutoloading(Backbone.Marionette.Layout);

class window.ActivitiesView extends AutoloadingView
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
    @$('.list').html('')
    for childView in @childViews
      @appendHtml @, childView

  reset: ->
    @closeChildViews()
    @collection.each @add, @
    @renderChildren()

  add: (model, collection) ->
    lastChildView = _.last(@childViews)

    unless lastChildView?.append(model)
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
    @$(".list").append childView.render().el

  newChildView: (model) ->
    ch = @collection.channel
    UserActivitiesGroupView.new
      model: model

  emptyViewOn: ->
    if @collection.channel.get('discover_stream?')
      @suggestedTopics = new SuggestedTopics()
      @suggestedTopics.fetch()
      @emptyView = new SuggestedTopicsView
        model: new Backbone.Model(current_url: @collection.link())
        collection: collectionDifference new SuggestedTopics, 'slug_title', @suggestedTopics, window.Channels
    else
      @emptyView = getTextView('Currently there are no activities related to this channel')

    @$('.js-empty-stream').html @emptyView.render().el

  emptyViewOff: ->
    if @emptyView?
      @emptyView.close()
      delete @emptyView

  addAtBottom:(view) -> @bottomRegion.show view

_.extend(ActivitiesView.prototype, ToggleMixin)
