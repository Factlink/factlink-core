class window.ActivitiesView extends AutoloadingView

  childViews: []

  initialize: (opts) ->
    this.collection.on('reset', this.reset, this);
    this.collection.on('add', this.add, this);
    this.itemView = ActivityItemView;

  render: () ->
    this.$el.html('')
    super arguments

  reset: () ->
    this.collection.each( this.add, this );
    this.render();

  add: (model) ->
    last = _.last(this.childViews);

    if (last && (last.appendable(model)))
      appendTo = last;
    else
      appendTo = this.newChildView(model);
      this.childViews.push(appendTo);
      appendTo.render();
      this.$el.append(appendTo.$el);

    appendTo.collection.add(model);

  newChildView: (model) ->
    ch = this.collection.channel;
    return new UserActivitiesView({model: model.getActivity(), collection: new ChannelActivities([], {channel: ch})});