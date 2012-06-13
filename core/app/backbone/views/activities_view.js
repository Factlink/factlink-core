window.ActivitiesView = Backbone.View.extend({

  childViews: [],

  initialize: function(opts) {
    this.collection.on('reset', this.reset, this);
    this.collection.bind('add', this.add, this);
    // this.collection.bind('remove', this.removeOne, this);

    this.itemView = ActivityItemView;
  },

  render: function() {
    var self = this;

    _.each(this.childViews, function(view) {
      view.render();
      self.$el.append(view.$el);
    });
  },

  reset: function() {
    this.collection.each( this.add, this );
    this.render();
  },

  add: function(model) {
    var last = _.last(this.childViews);
    var appendTo;

    if (last && (last.appendable(model))) {
      appendTo = last;
    } else {
      appendTo = this.newChildView(model);
      this.childViews.push(appendTo);
    }

    appendTo.collection.add(model);
  },

  newChildView: function(model) {
    var ch = this.collection.channel;
    return new UserActivitiesView({model: model.getActivity(), collection: new ChannelActivities([], {channel: ch})});
  }

});
