window.ActivitiesView = Backbone.CollectionView.extend({

  containerSelector: '#channel-listing',

  initialize: function(opts) {
    var self = this;
    this.modelView = ActivityView;

    this.collection.bind('add',   this.add, this);
    this.collection.bind('reset', this.reset, this);
  }

});
