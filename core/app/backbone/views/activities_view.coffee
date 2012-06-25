AutoloadingView = extendWithAutoloading(Backbone.Marionette.ItemView);

class window.ActivitiesView extends AutoloadingView

  childViews: []

  template: 'activities/list'

  initialize: (opts) ->
    @collection.on('reset', this.reset, this)
    @collection.on('add', this.add, this)
    @itemView = ActivityItemView
    @collection.on 'startLoading stopLoading', => this.renderLoading()

  renderLoading: ->
    if this.collection._loading
      this.$('div.loading').show()
    else
      this.$('div.loading').hide()


  render: ->
    super arguments
    this.renderLoading()
    this.renderChildren()

  renderChildren: ->
    this.$('.list').html('')
    for childView in @childViews
      this.appendHtml(this, childView)

  reset: ->
    this.collection.each( this.add, this );
    this.renderChildren()

  add: (model) ->
    last = _.last(this.childViews);

    if (last && (last.appendable(model)))
      appendTo = last
    else
      appendTo = this.newChildView(model)
      this.childViews.push(appendTo)
      this.appendHtml(this, appendTo)

    appendTo.collection.add(model);

  beforeClose: ->
    childView.close for childView in @childViews

  appendHtml: (collectionView, childView) ->
    childView.render()
    this.$(".list").append(childView.$el)

  newChildView: (model) ->
    ch = this.collection.channel
    new UserActivitiesView
      model: model.getActivity(),
      collection: new ChannelActivities([], {channel: ch})