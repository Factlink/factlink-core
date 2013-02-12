AutoloadingView = extendWithAutoloading(Backbone.Marionette.Layout);

class ActivititesBasicEmptyView extends Backbone.Marionette.ItemView
  className: 'empty_stream_content'
  template: """
    Currently there are no activities related to this channel
  """

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
      if @collection.channel.get('discover_stream?')
        @topTopics = new TopTopics()
        @topTopics.fetch()
        @emptyView = new TopTopicsView
          model: new Backbone.Model(current_url: @collection.link())
          collection: collectionDifference new TopTopics, 'slug_title', @topTopics, window.Channels
      else
        @emptyView = new ActivititesBasicEmptyView

      @$('.js-empty-stream').html @emptyView.render().el

  emptyViewOff: ->
    if @emptyView?
      @emptyView.close()
      delete @emptyView

  addAtBottom:(view) -> @bottomRegion.show view

_.extend(ActivitiesView.prototype, ToggleMixin)
