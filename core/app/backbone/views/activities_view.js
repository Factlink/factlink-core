window.ActivitiesView = Backbone.Marionette.CollectionView.extend({
  initialize: function(opts) {
    this.itemView = ActivityView;
  }
});
