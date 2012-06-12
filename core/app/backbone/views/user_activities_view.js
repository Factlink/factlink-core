window.UserActivitiesView = Backbone.Marionette.CompositeView.extend({

  template: 'activities/user-activities',
  className: 'activity-block',

  initialize: function(opts) {
    this.itemView = ActivityItemView;
  },

  appendable: function(model) {
    return this.model.get('username') === model.get('username');
  },

  appendHtml: function(collectionView, itemView){
    collectionView.$(".the-activities").append(itemView.el);
  }

});
