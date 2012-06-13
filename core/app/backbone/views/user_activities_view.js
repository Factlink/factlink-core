window.UserActivitiesView = Backbone.Marionette.CompositeView.extend({

  template:  'activities/user-activities',
  className: 'activity-block',

  initialize: function(opts) {
    this.itemView = ActivityItemView;
  },

  appendable: function(new_model) {
    var same_user                  = this.model.get('username') === new_model.get('username');
    var new_subject_is_channel     =  new_model.get('subject_class') === "Channel";
    var current_subject_is_channel = this.model.get('subject_class') === "Channel";

    return same_user && new_subject_is_channel && current_subject_is_channel;
  },

  appendHtml: function(collectionView, itemView){
    collectionView.$(".the-activities").append(itemView.el);
  }

});
