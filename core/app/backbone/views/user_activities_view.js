window.UserActivitiesView = Backbone.Marionette.CompositeView.extend({

  template: 'activities/user-activities',
  className: 'activity-block',

  initialize: function(opts) {
    this.itemView = ActivityItemView;
  },

  appendable: function(model) {
    var same_user           = this.model.get('username') === model.get('username');
    var is_channel_activity = model.get('subject_class') === "Channel";
    return same_user && is_channel_activity;
  },

  appendHtml: function(collectionView, itemView){
    collectionView.$(".the-activities").append(itemView.el);
  }

});
