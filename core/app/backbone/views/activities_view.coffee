AutoloadingView = extendWithAutoloading(Backbone.Marionette.ItemView);

class window.ActivitiesView extends AutoloadingView

  template: 'activities/list'

  initialize: (opts) ->
    @collection.on('reset', @reset, this)
    @collection.on('add', @add, this)

    @addShowHideToggle('loadingIndicator', 'div.loading');
    @collection.on('startLoading', @loadingIndicatorOn, this);
    @collection.on('stopLoading', @loadingIndicatorOff, this);

    @addShowHideToggle('emptyView', 'div.empty_stream');

    @childViews = []

  onRender: ->
    @renderChildren()

  renderChildren: ->
    @$('.list').html('')
    for childView in @childViews
      @appendHtml(this, childView)

  reset: ->
    @collection.each( @add, this );
    @renderChildren()

  add: (model) ->
    last = _.last(@childViews);

    if (last && (last.appendable(model)))
      appendTo = last
    else
      appendTo = @newChildView(model)
      @childViews.push(appendTo)
      @appendHtml(this, appendTo)

    appendTo.collection.add(model);

  beforeClose: ->
    childView.close() for childView in @childViews

  appendHtml: (collectionView, childView) ->
    childView.render()
    @$(".list").append(childView.$el)

  newChildView: (model) ->
    ch = @collection.channel
    new UserActivitiesView
      model: model.getActivity(),
      collection: new ChannelActivities([], {channel: ch})

_.extend(ActivitiesView.prototype, ToggleMixin)