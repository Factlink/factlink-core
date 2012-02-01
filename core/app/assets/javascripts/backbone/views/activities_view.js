window.ActivitiesView = Backbone.CollectionView.extend({

  containerSelector: '#activity_for_channel',

  initialize: function(opts) {
    this.modelView = ActivityView;

    this.collection.bind('add',   this.add, this);
    this.collection.bind('reset', this.reset, this);
  }
});
