class window.UserActivitiesView extends Backbone.Marionette.CompositeView

  template:  'activities/user-activities'
  className: 'activity-block'
  itemView: Backbone.View
  itemViewContainer: ".the-activities"

  appendable: (new_model) ->
    same_user                  = this.model.get('username') == new_model.get('username')
    new_subject_is_channel     =  new_model.get('subject_class') == "Channel"
    current_subject_is_channel = this.model.get('subject_class') == "Channel"
    same_user && new_subject_is_channel && current_subject_is_channel

  buildItemView: (item, ItemView) ->
    #ignore ItemView
    newItemView = window.getActivityItemViewFor(item)
    Backbone.Marionette.CompositeView.prototype.buildItemView.call(this,item, newItemView)
