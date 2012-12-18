AutoloadingView = extendWithAutoloading(Backbone.Marionette.Layout);

class window.ActivitiesView extends AutoloadingView

  template: 'activities/list'

  regions:
    bottom: '.below_activities'

  initialize: (opts) ->
    @collection.on('reset remove', @reset, this)
    @collection.on('add', @add, this)

    @addShowHideToggle('loadingIndicator', 'div.loading');
    @collection.on('startLoading', @loadingIndicatorOn, this);
    @collection.on('stopLoading', @loadingIndicatorOff, this);

    @childViews = []

  onRender: ->
    @renderChildren()

  renderChildren: ->
    @$('.list').html('')
    for childView in @childViews
      @appendHtml(this, childView)

  reset: ->
    @closeChildViews()
    @collection.each( @add, this );
    @renderChildren()

  add: (model, collection, options) ->
    index = options.index

    appendableCandidate =
      if index == 0
        _.first(@childViews)
      else
        _.last(@childViews);

    appendTo =
      if (appendableCandidate && (appendableCandidate.appendable(model)))
        model.set('render_fact': false)
        appendableCandidate
      else
        model.set('render_fact': true)
        @createNewAppendable(model, index)

    appendTo.collection.add(model, at: index);

  createNewAppendable: (model, index) ->
      appendTo = @newChildView(model)
      if index == 0
        @childViews.unshift(appendTo)
      else
        @childViews.push(appendTo)
      @appendHtml(this, appendTo, index)
      appendTo


  closeChildViews: ->
    childView.close() for childView in @childViews
    @childViews = []

  onBeforeClose: -> @closeChildViews()


  appendHtml: (collectionView, childView, index) ->
    childView.render()
    if index == 0
      @$(".list").prepend(childView.$el)
    else
      @$(".list").append(childView.$el)

  newChildView: (model) ->
    ch = @collection.channel
    UserActivitiesView.new
      model: model.getActivity(),
      collection: new ChannelActivities([], {channel: ch})

  emptyViewOn: ->
    if @collection.channel.get('discover_stream?')
      @suggestedTopics = new SuggestedTopics()
      @suggestedTopics.fetch()
      @emptyView = new SuggestedTopicsView
        model: new Backbone.Model({current_url: @collection.link()})
        collection: collectionDifference(new SuggestedTopics, 'slug_title', @suggestedTopics, window.Channels);
    else
      @emptyView = getTextView('Currently there are no activities related to this channel')

    @$('.empty_stream').html(@emptyView.render().el)


  emptyViewOff: ->
    if @emptyView
      @emptyView.close()
      delete @emptyView

  addAtBottom:(view)-> @bottom.show(view)

_.extend(ActivitiesView.prototype, ToggleMixin)
